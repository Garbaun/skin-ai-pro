# Firebase Configuration Guide for Skin AI Pro

This guide will help you set up Firebase for your Skin AI Pro Flutter application.

## Prerequisites

1. **Create a Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Click "Create Project"
   - Enter project name: "Skin AI Pro"
   - Enable Google Analytics (recommended)
   - Select your Analytics account/region

2. **Add Android App**
   - Click the Android icon in your Firebase project
   - Package name: `com.skinai.pro`
   - App nickname: `Skin AI Pro`
   - Download `google-services.json`
   - Replace the placeholder file at: `android/app/google-services.json`

3. **Add iOS App**
   - Click the iOS icon in your Firebase project
   - Bundle ID: `com.skinai.pro`
   - App nickname: `Skin AI Pro`
   - Download `GoogleService-Info.plist`
   - Replace the placeholder file at: `ios/Runner/GoogleService-Info.plist`

## Firebase Services Setup

### 1. Authentication

Enable the following authentication methods:
- **Email/Password**: Enable in Firebase Console > Authentication > Sign-in method
- **Google Sign-In**: 
  - Enable in Firebase Console
  - Add your SHA-1 fingerprint for Android
  - Configure OAuth consent screen

### 2. Firestore Database

- Go to Firebase Console > Firestore Database
- Click "Create Database"
- Choose your location (e.g., `europe-west3`)
- Start in production mode (recommended)

### 3. Storage

- Go to Firebase Console > Storage
- Click "Get Started"
- Choose your location (same as Firestore)
- Set up security rules (see below)

### 4. Analytics

- Automatically enabled when you create the project
- No additional setup required

### 5. Crashlytics

- Go to Firebase Console > Crashlytics
- Click "Enable Crashlytics"
- Follow the setup instructions

## Security Rules

### Firestore Security Rules

Add these rules to your Firestore database:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Subcollections inherit parent rules
      match /{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

### Storage Security Rules

Add these rules to your Storage:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Users can only access their own files
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Android Configuration

### 1. Update `android/build.gradle`

Add the Google Services plugin:

```gradle
buildscript {
    ext.kotlin_version = '1.7.10'
    dependencies {
        classpath 'com.android.tools.build:gradle:7.2.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.google.gms:google-services:4.3.15' // Add this line
    }
}
```

### 2. Update `android/app/build.gradle`

Apply the Google Services plugin:

```gradle
apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply plugin: 'com.google.gms.google-services' // Add this line
```

### 3. Update `android/app/src/main/AndroidManifest.xml`

Add internet permission:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

## iOS Configuration

### 1. Update `ios/Runner/Info.plist`

Add the required permissions:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to analyze your skin</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to analyze your skin images</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>This app needs photo library access to save analysis results</string>
```

### 2. Enable Keychain Sharing (for Google Sign-In)

In Xcode:
1. Select your project
2. Go to "Signing & Capabilities"
3. Click "+ Capability"
4. Add "Keychain Sharing"
5. Add keychain group: `$(AppIdentifierPrefix)com.skinai.pro`

## Testing the Setup

1. **Run the app**:
   ```bash
   flutter run
   ```

2. **Test Authentication**:
   - Try email/password sign-up
   - Try Google sign-in
   - Check if user data is saved to Firestore

3. **Test Storage**:
   - Upload a profile picture
   - Upload an analysis image
   - Check if files appear in Firebase Storage

4. **Test Analytics**:
   - Check Firebase Console > Analytics > Dashboard
   - Events should appear within 24 hours

## Troubleshooting

### Common Issues

1. **Google Sign-In not working on Android**:
   - Make sure you added the correct SHA-1 fingerprint
   - Check if OAuth consent screen is configured
   - Verify the `google-services.json` file is in the correct location

2. **Firestore permission errors**:
   - Check if security rules are properly configured
   - Verify user authentication state
   - Check Firestore indexes if you get index errors

3. **Storage upload failures**:
   - Check storage security rules
   - Verify file size limits
   - Check network connectivity

4. **iOS build issues**:
   - Run `pod install` in the ios directory
   - Clean build folder in Xcode
   - Check if GoogleService-Info.plist is added to the project

### Debug Commands

```bash
# Clean Flutter build
flutter clean

# Get dependencies
flutter pub get

# For iOS
cd ios && pod install && cd ..

# Run in debug mode
flutter run --debug

# Check for issues
flutter doctor -v
```

## Next Steps

1. **Set up Firebase Functions** (optional):
   - For server-side logic
   - For push notifications
   - For scheduled tasks

2. **Configure Push Notifications**:
   - Enable Firebase Cloud Messaging
   - Set up notification channels
   - Test push notifications

3. **Set up Firebase Remote Config**:
   - For feature flags
   - For A/B testing
   - For dynamic configuration

## Support

If you encounter any issues:
1. Check Firebase Console for error logs
2. Review the troubleshooting section above
3. Check the Flutter and Firebase documentation
4. Contact Firebase support if needed

---

**Note**: The configuration files (`google-services.json` and `GoogleService-Info.plist`) contain sensitive information. Never commit these files to public repositories. Add them to your `.gitignore` file.