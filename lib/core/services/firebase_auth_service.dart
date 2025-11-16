import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'firebase_service.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Get current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Get current user ID
  String? get currentUserId => currentUser?.uid;

  /// Sign in with email and password
  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await FirebaseService.instance.setUserId(credential.user!.uid);
        await _createUserDocument(credential.user!);
        return _userFromFirebase(credential.user!);
      }
      return null;
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Sign up with email and password
  Future<UserModel?> signUpWithEmail(String email, String password, String name) async {
    try {
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);
        await FirebaseService.instance.setUserId(credential.user!.uid);
        await _createUserDocument(credential.user!);
        return _userFromFirebase(credential.user!);
      }
      return null;
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        await FirebaseService.instance.setUserId(userCredential.user!.uid);
        await _createUserDocument(userCredential.user!);
        return _userFromFirebase(userCredential.user!);
      }
      return null;
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      
      await FirebaseService.instance.setUserId('');
      
      await FirebaseService.instance.logEvent('user_signout', {});
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      
      await FirebaseService.instance.logEvent('password_reset', {
        'email': email,
      });
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateProfile({String? name, String? photoURL}) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No user logged in');

      if (name != null) await user.updateDisplayName(name);
      if (photoURL != null) await user.updatePhotoURL(photoURL);
      
      await _updateUserDocument(user);
      
      await FirebaseService.instance.logEvent('profile_updated', {
        'name_updated': name != null,
        'photo_updated': photoURL != null,
      });
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Convert Firebase User to UserModel
  UserModel _userFromFirebase(User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      photoURL: user.photoURL,
      isEmailVerified: user.emailVerified,
      analysisCredits: 3, // Default credits for new users
      isPremium: false,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
  }

  /// Create user document in Firestore
  Future<void> _createUserDocument(User user) async {
    try {
      final userDoc = FirebaseService.instance.firestore
          .collection(FirebaseService.usersCollection)
          .doc(user.uid);

      final userData = {
        'email': user.email,
        'name': user.displayName ?? '',
        'photoURL': user.photoURL,
        'isEmailVerified': user.emailVerified,
        'analysisCredits': 3, // Default credits
        'isPremium': false,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await userDoc.set(userData, SetOptions(merge: true));
      
      await FirebaseService.instance.logEvent('user_created', {
        'user_id': user.uid,
        'email': user.email,
      });
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Update user document in Firestore
  Future<void> _updateUserDocument(User user) async {
    try {
      final userDoc = FirebaseService.instance.firestore
          .collection(FirebaseService.usersCollection)
          .doc(user.uid);

      await userDoc.update({
        'name': user.displayName ?? '',
        'photoURL': user.photoURL,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Get user data from Firestore
  Future<UserModel?> getUserData(String userId) async {
    try {
      final userDoc = await FirebaseService.instance.firestore
          .collection(FirebaseService.usersCollection)
          .doc(userId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data()!;
        return UserModel(
          id: userId,
          email: data['email'] ?? '',
          name: data['name'] ?? '',
          photoURL: data['photoURL'],
          isEmailVerified: data['isEmailVerified'] ?? false,
          analysisCredits: data['analysisCredits'] ?? 0,
          isPremium: data['isPremium'] ?? false,
          createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          lastLoginAt: (data['lastLoginAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Update user credits
  Future<void> updateUserCredits(String userId, int credits) async {
    try {
      final userDoc = FirebaseService.instance.firestore
          .collection(FirebaseService.usersCollection)
          .doc(userId);

      await userDoc.update({
        'analysisCredits': credits,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      await FirebaseService.instance.logEvent('credits_updated', {
        'user_id': userId,
        'credits': credits,
      });
    } catch (e) {
      await FirebaseService.instance.recordError(e, StackTrace.current);
      rethrow;
    }
  }
}