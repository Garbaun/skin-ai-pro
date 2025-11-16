import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

abstract class AppLocalizations {
  static const AppLocalizationsDelegate delegate = AppLocalizationsDelegate();

  static const supportedLocales = [
    Locale('en', 'US'), // English
    Locale('tr', 'TR'), // Turkish
  ];

  static const localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  // Common
  String get appTitle;
  String get cancel;
  String get save;
  String get delete;
  String get edit;
  String get confirm;
  String get yes;
  String get no;
  String get loading;
  String get error;
  String get success;
  String get retry;
  String get skip;
  String get next;
  String get back;
  String get continueText;
  String get finish;
  String get close;
  String get search;
  String get filter;
  String get sort;
  String get clear;
  String get apply;
  String get reset;
  String get select;
  String get selected;
  String get minutes;
  String get hours;
  String get days;
  String get weeks;
  String get months;
  String get years;

  // Auth
  String get login;
  String get logout;
  String get signUp;
  String get email;
  String get password;
  String get confirmPassword;
  String get forgotPassword;
  String get orContinueWith;
  String get googleSignIn;
  String get appleSignIn;
  String get dontHaveAccount;
  String get alreadyHaveAccount;
  String get invalidEmail;
  String get passwordTooShort;
  String get passwordsDoNotMatch;
  String get loginFailed;
  String get signUpFailed;
  String get logoutConfirm;
  String get logoutSuccess;

  // Home
  String get welcome;
  String get welcomeBack;
  String get startAnalysis;
  String get viewHistory;
  String get myProfile;
  String get settings;
  String get analysisHistory;
  String get products;
  String get tracking;
  String get credits;
  String get premium;
  String get upgradeToPremium;
  String get analysisCredits;
  String get remainingCredits;
  String get buyCredits;
  String get noCredits;
  String get purchaseMoreCredits;

  // Analysis
  String get skinAnalysis;
  String get startSkinAnalysis;
  String get selectImage;
  String get takePhoto;
  String get chooseFromGallery;
  String get selectSymptoms;
  String get describeSymptoms;
  String get symptomsHint;
  String get skinType;
  String get skinConcerns;
  String get sensitivityLevel;
  String get analyze;
  String get analyzing;
  String get analysisComplete;
  String get analysisFailed;
  String get uploadImageFirst;
  String get selectAtLeastOneSymptom;
  String get imageQualityPoor;
  String get retakePhoto;
  String get usePhoto;
  String get photoTips;
  String get goodLighting;
  String get cleanFace;
  String get noMakeup;
  String get naturalExpression;
  String get multipleAngles;

  // Results
  String get analysisResults;
  String get skinAnalysisReport;
  String get overallSkinHealth;
  String get skinTypeResult;
  String get primaryConcerns;
  String get secondaryConcerns;
  String get sensitivityAssessment;
  String get recommendations;
  String get productRecommendations;
  String get routineRecommendations;
  String get lifestyleTips;
  String get viewDetails;
  String get saveResults;
  String get shareResults;
  String get downloadReport;
  String get similarResults;
  String get confidenceLevel;
  String get veryLow;
  String get low;
  String get medium;
  String get high;
  String get veryHigh;

  // Products
  String get recommendedProducts;
  String get productDetails;
  String get ingredients;
  String get howToUse;
  String get price;
  String get buyNow;
  String get addToCart;
  String get viewProduct;
  String get productCategories;
  String get cleansers;
  String get moisturizers;
  String get serums;
  String get sunscreens;
  String get toners;
  String get masks;
  String get exfoliants;
  String get eyeCare;
  String get lipCare;
  String get brands;
  String get filterBy;
  String get sortBy;
  String get priceRange;
  String get skinTypeFilter;
  String get concernFilter;

  // Tracking
  String get waterTracking;
  String get waterReminder;
  String get dailyWaterGoal;
  String get waterIntake;
  String get glasses;
  String get ml;
  String get oz;
  String addWater(String amount);
  String get waterProgress;
  String get dailyGoalReached;
  String get reminderSettings;
  String get reminderInterval;
  String get selectInterval;
  String get reminderTime;
  String get startTime;
  String get endTime;
  String get enableReminders;
  String get disableReminders;
  String get remindersEnabled;
  String get remindersDisabled;
  String get weeklyStats;
  String get monthlyStats;
  String get averageDaily;
  String get bestDay;
  String get streak;
  String get days;

  // Skincare Routine
  String get skincareRoutine;
  String get morningRoutine;
  String get eveningRoutine;
  String get weeklyRoutine;
  String get routineSteps;
  String get stepNumber;
  String get completed;
  String get markComplete;
  String get routineProgress;
  String get routineCompleted;
  String get customizeRoutine;
  String get addStep;
  String get removeStep;
  String get stepName;
  String get stepDescription;
  String get stepDuration;
  String get productUsed;
  String get routineHistory;
  String get routineStats;

  // History
  String get analysisHistory;
  String get viewAll;
  String get noHistory;
  String get historyEmpty;
  String get date;
  String get time;
  String get results;
  String get viewDetails;
  String get deleteHistory;
  String get deleteConfirm;
  String get historyDeleted;
  String get clearAll;
  String get clearHistory;
  String get exportHistory;
  String get filterByDate;
  String get filterByType;
  String get sortByDate;
  String get sortByType;
  String get ascending;
  String get descending;

  // Settings
  String get settings;
  String get accountSettings;
  String get profileSettings;
  String get notificationSettings;
  String get privacySettings;
  String get themeSettings;
  String get languageSettings;
  String get dataSettings;
  String get about;
  String get help;
  String get contactUs;
  String get rateApp;
  String get shareApp;
  String get termsOfService;
  String get privacyPolicy;
  String get appVersion;
  String get darkMode;
  String get lightTheme;
  String get darkTheme;
  String get systemTheme;
  String get turkish;
  String get english;
  String get selectLanguage;
  String get changePassword;
  String get deleteAccount;
  String get exportData;
  String get importData;
  String get clearCache;
  String get cacheCleared;
  String get notifications;
  String get emailNotifications;
  String get pushNotifications;
  String get analysisNotifications;
  String get reminderNotifications;
  String get marketingNotifications;
  String get dataPrivacy;
  String get analytics;
  String get crashReporting;
  String get personalizedAds;
  String get locationServices;

  // Premium
  String get premiumFeatures;
  String get upgradeToPremium;
  String get premiumBenefits;
  String get unlimitedAnalyses;
  String get advancedAnalysis;
  String get prioritySupport;
  String get noAds;
  String get exclusiveContent;
  String get premiumProducts;
  String get monthlySubscription;
  String get yearlySubscription;
  String get lifetimeAccess;
  String get subscriptionDetails;
  String get paymentMethods;
  String get subscriptionStatus;
  String get activeSubscription;
  String get subscriptionExpires;
  String get cancelSubscription;
  String get manageSubscription;
  String get subscriptionCancelled;
  String get subscriptionRenewed;

  // Errors
  String get networkError;
  String get serverError;
  String get authenticationError;
  String get permissionError;
  String get cameraError;
  String get storageError;
  String get imageError;
  String get analysisError;
  String get paymentError;
  String get subscriptionError;
  String get tryAgainLater;
  String get contactSupport;
  String get checkConnection;
  String get enablePermissions;
  String get insufficientStorage;
  String get imageTooLarge;
  String get invalidImageFormat;

  // Health Warnings
  String get medicalDisclaimer;
  String get notMedicalAdvice;
  String get consultDermatologist;
  String get professionalOpinion;
  String get resultsNotGuaranteed;
  String get individualResults;
  String get patchTest;
  String get discontinueUse;
  String get allergicReaction;
  String get seekMedicalAttention;
  String get emergencyContact;
  String get disclaimer;
  String get terms;
  String get privacy;
  String get iUnderstand;
  String get acceptTerms;
  String get mustAcceptTerms;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'tr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'tr':
        return AppLocalizationsTr();
      case 'en':
      default:
        return AppLocalizationsEn();
    }
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}