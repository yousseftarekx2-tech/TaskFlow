import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @manageTaskReminders.
  ///
  /// In en, this message translates to:
  /// **'Manage task reminders'**
  String get manageTaskReminders;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @manageSoundsAlerts.
  ///
  /// In en, this message translates to:
  /// **'Manage sounds and alerts'**
  String get manageSoundsAlerts;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @useDarkAppearance.
  ///
  /// In en, this message translates to:
  /// **'Use dark appearance'**
  String get useDarkAppearance;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @productivity.
  ///
  /// In en, this message translates to:
  /// **'Productivity'**
  String get productivity;

  /// No description provided for @habits.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get habits;

  /// No description provided for @manageProductivityHabits.
  ///
  /// In en, this message translates to:
  /// **'Manage productivity habits'**
  String get manageProductivityHabits;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @aboutTaskFlow.
  ///
  /// In en, this message translates to:
  /// **'About TaskFlow'**
  String get aboutTaskFlow;

  /// No description provided for @learnMoreAboutTaskFlow.
  ///
  /// In en, this message translates to:
  /// **'Learn more about TaskFlow'**
  String get learnMoreAboutTaskFlow;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @privacyAndData.
  ///
  /// In en, this message translates to:
  /// **'Privacy and data'**
  String get privacyAndData;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @reviewOurTerms.
  ///
  /// In en, this message translates to:
  /// **'Review our terms'**
  String get reviewOurTerms;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @taskFlow.
  ///
  /// In en, this message translates to:
  /// **'TaskFlow'**
  String get taskFlow;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// No description provided for @createTask.
  ///
  /// In en, this message translates to:
  /// **'Create Task'**
  String get createTask;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTask;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @taskTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Title'**
  String get taskTitle;

  /// No description provided for @enterTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter task title'**
  String get enterTaskTitle;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @addTaskDescriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Add task description (optional)'**
  String get addTaskDescriptionOptional;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @noCategoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get noCategoriesYet;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;

  /// No description provided for @pleaseEnterTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a task title'**
  String get pleaseEnterTaskTitle;

  /// No description provided for @pleaseSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get pleaseSelectCategory;

  /// No description provided for @pleaseSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get pleaseSelectDate;

  /// No description provided for @pleaseSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Please select a time'**
  String get pleaseSelectTime;

  /// No description provided for @taskCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Task created successfully'**
  String get taskCreatedSuccessfully;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @enterCategoryName.
  ///
  /// In en, this message translates to:
  /// **'Enter category name'**
  String get enterCategoryName;

  /// No description provided for @chooseColor.
  ///
  /// In en, this message translates to:
  /// **'Choose Color'**
  String get chooseColor;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @stayOrganizedStayFocused.
  ///
  /// In en, this message translates to:
  /// **'Stay organized. Stay focused.'**
  String get stayOrganizedStayFocused;

  /// No description provided for @aboutTaskFlowDescription.
  ///
  /// In en, this message translates to:
  /// **'TaskFlow helps you organize your tasks, manage your time, and stay focused on what matters.'**
  String get aboutTaskFlowDescription;

  /// No description provided for @ourGoal.
  ///
  /// In en, this message translates to:
  /// **'Our Goal'**
  String get ourGoal;

  /// No description provided for @ourGoalDescription.
  ///
  /// In en, this message translates to:
  /// **'Make daily task management simple, clear, and productive.'**
  String get ourGoalDescription;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// No description provided for @builtWith.
  ///
  /// In en, this message translates to:
  /// **'Built with'**
  String get builtWith;

  /// No description provided for @madeForBetterProductivity.
  ///
  /// In en, this message translates to:
  /// **'Made for better productivity'**
  String get madeForBetterProductivity;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get createNewPassword;

  /// No description provided for @newPasswordMustBeDifferent.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be different from'**
  String get newPasswordMustBeDifferent;

  /// No description provided for @previousOne.
  ///
  /// In en, this message translates to:
  /// **'your previous password.'**
  String get previousOne;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get enterNewPassword;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your new password'**
  String get confirmNewPassword;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordDescription1.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you'**
  String get forgotPasswordDescription1;

  /// No description provided for @forgotPasswordDescription2.
  ///
  /// In en, this message translates to:
  /// **'a link to reset your password.'**
  String get forgotPasswordDescription2;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @enterYourEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterYourEmailAddress;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get backToSignIn;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @incorrectEmailOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get incorrectEmailOrPassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @createYourAccountToStartOrganized.
  ///
  /// In en, this message translates to:
  /// **'Create your account to start organizing'**
  String get createYourAccountToStartOrganized;

  /// No description provided for @yourDailyTasks.
  ///
  /// In en, this message translates to:
  /// **'your daily tasks'**
  String get yourDailyTasks;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// No description provided for @pleaseEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @pleaseConfirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmYourPassword;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @verifyYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyYourEmail;

  /// No description provided for @verificationCodeDescription1.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit verification code sent to'**
  String get verificationCodeDescription1;

  /// No description provided for @verificationCodeDescription2.
  ///
  /// In en, this message translates to:
  /// **'your email.'**
  String get verificationCodeDescription2;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @didntReceiveTheCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get didntReceiveTheCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in'**
  String get resendCodeIn;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sun;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// Number of tasks for the selected day
  ///
  /// In en, this message translates to:
  /// **'{count} tasks'**
  String taskCount(int count);

  /// No description provided for @noTasksForThisDay.
  ///
  /// In en, this message translates to:
  /// **'No tasks for this day'**
  String get noTasksForThisDay;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @organizeYourTasks.
  ///
  /// In en, this message translates to:
  /// **'Organize your tasks'**
  String get organizeYourTasks;

  /// No description provided for @noTasksInThisCategory.
  ///
  /// In en, this message translates to:
  /// **'No tasks in this category'**
  String get noTasksInThisCategory;

  /// Message shown when there are no tasks in the category.
  ///
  /// In en, this message translates to:
  /// **'Create a task and assign it to {categoryName}.'**
  String createTaskAndAssignToCategory(String categoryName);

  /// No description provided for @focusTimer.
  ///
  /// In en, this message translates to:
  /// **'Focus Timer'**
  String get focusTimer;

  /// No description provided for @stayFocusedOneSessionAtATime.
  ///
  /// In en, this message translates to:
  /// **'Stay focused, one session at a time.'**
  String get stayFocusedOneSessionAtATime;

  /// No description provided for @preparePresentation.
  ///
  /// In en, this message translates to:
  /// **'Prepare presentation'**
  String get preparePresentation;

  /// No description provided for @focusSession.
  ///
  /// In en, this message translates to:
  /// **'Focus Session'**
  String get focusSession;

  /// No description provided for @breakLabel.
  ///
  /// In en, this message translates to:
  /// **'Break'**
  String get breakLabel;

  /// No description provided for @readyToFocus.
  ///
  /// In en, this message translates to:
  /// **'Ready to focus'**
  String get readyToFocus;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @startFocus.
  ///
  /// In en, this message translates to:
  /// **'Start Focus'**
  String get startFocus;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @allSessionsCompleted.
  ///
  /// In en, this message translates to:
  /// **'All sessions completed'**
  String get allSessionsCompleted;

  /// No description provided for @breakAfterSession.
  ///
  /// In en, this message translates to:
  /// **'Break after session {session}'**
  String breakAfterSession(Object session);

  /// No description provided for @sessionOf.
  ///
  /// In en, this message translates to:
  /// **'Session {current} of {total}'**
  String sessionOf(Object current, Object total);

  /// No description provided for @todaysFocus.
  ///
  /// In en, this message translates to:
  /// **'Today\'s focus: {time}'**
  String todaysFocus(Object time);

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{duration} minutes'**
  String minutes(Object duration);

  /// No description provided for @allFocusSessionsCompleted.
  ///
  /// In en, this message translates to:
  /// **'All focus sessions completed • Great work!'**
  String get allFocusSessionsCompleted;

  /// No description provided for @breakInProgress.
  ///
  /// In en, this message translates to:
  /// **'Break in progress • {duration}-minute break'**
  String breakInProgress(Object duration);

  /// No description provided for @finalFocusSession.
  ///
  /// In en, this message translates to:
  /// **'Final focus session • Finish strong'**
  String get finalFocusSession;

  /// No description provided for @nextBreak.
  ///
  /// In en, this message translates to:
  /// **'Next break: {duration} minutes after this session'**
  String nextBreak(Object duration);

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @letsMakeTodayProductive.
  ///
  /// In en, this message translates to:
  /// **'Let\'s make today productive'**
  String get letsMakeTodayProductive;

  /// No description provided for @todaysProgress.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Progress'**
  String get todaysProgress;

  /// Displays the number of completed tasks out of today's total tasks
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} tasks completed'**
  String tasksCompleted(int completed, int total);

  /// No description provided for @todaysTasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Tasks'**
  String get todaysTasks;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @noTasksForToday.
  ///
  /// In en, this message translates to:
  /// **'No tasks for today'**
  String get noTasksForToday;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @noUpcomingTasks.
  ///
  /// In en, this message translates to:
  /// **'No upcoming tasks'**
  String get noUpcomingTasks;

  /// No description provided for @am.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get am;

  /// No description provided for @pm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pm;

  /// No description provided for @organizeYourTasksOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Organize Your Tasks'**
  String get organizeYourTasksOnboarding;

  /// No description provided for @organizeYourTasksOnboardingDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep all your daily tasks organized in one beautiful place and stay productive every day.'**
  String get organizeYourTasksOnboardingDescription;

  /// No description provided for @neverMissADeadline.
  ///
  /// In en, this message translates to:
  /// **'Never miss a deadline'**
  String get neverMissADeadline;

  /// No description provided for @neverMissADeadlineDescription.
  ///
  /// In en, this message translates to:
  /// **'Get smart reminders and notifications so you never forget important tasks and deadlines again.'**
  String get neverMissADeadlineDescription;

  /// No description provided for @achieveYourGoals.
  ///
  /// In en, this message translates to:
  /// **'Achieve Your Goals'**
  String get achieveYourGoals;

  /// No description provided for @achieveYourGoalsDescription.
  ///
  /// In en, this message translates to:
  /// **'Track your progress, build powerful habits, and accomplish more every day with TaskFlow.'**
  String get achieveYourGoalsDescription;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// Displays how many days remain until an upcoming task.
  ///
  /// In en, this message translates to:
  /// **'In {days} days'**
  String inDays(int days);

  /// No description provided for @main.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get main;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @focus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focus;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @allTasks.
  ///
  /// In en, this message translates to:
  /// **'All Tasks'**
  String get allTasks;

  /// No description provided for @completedTasks.
  ///
  /// In en, this message translates to:
  /// **'Completed Tasks'**
  String get completedTasks;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @readAll.
  ///
  /// In en, this message translates to:
  /// **'Read all'**
  String get readAll;

  /// No description provided for @recentNotifications.
  ///
  /// In en, this message translates to:
  /// **'Recent notifications'**
  String get recentNotifications;

  /// No description provided for @stayUpdatedWithYourTasks.
  ///
  /// In en, this message translates to:
  /// **'Stay updated with your tasks.'**
  String get stayUpdatedWithYourTasks;

  /// No description provided for @unreadCount.
  ///
  /// In en, this message translates to:
  /// **'{count} unread'**
  String unreadCount(Object count);

  /// No description provided for @taskCompletedNotification.
  ///
  /// In en, this message translates to:
  /// **'Task completed'**
  String get taskCompletedNotification;

  /// No description provided for @completedFlutterUiTask.
  ///
  /// In en, this message translates to:
  /// **'You completed your Flutter UI task.'**
  String get completedFlutterUiTask;

  /// No description provided for @taskOverdueNotification.
  ///
  /// In en, this message translates to:
  /// **'Task overdue'**
  String get taskOverdueNotification;

  /// No description provided for @overdueTaskMessage.
  ///
  /// In en, this message translates to:
  /// **'Your \"Review project design\" task is overdue.'**
  String get overdueTaskMessage;

  /// No description provided for @taskReminderNotification.
  ///
  /// In en, this message translates to:
  /// **'Task reminder'**
  String get taskReminderNotification;

  /// No description provided for @taskStartsIn30Minutes.
  ///
  /// In en, this message translates to:
  /// **'Your development task starts in 30 minutes.'**
  String get taskStartsIn30Minutes;

  /// No description provided for @completedTeamMeetingTask.
  ///
  /// In en, this message translates to:
  /// **'You completed the team meeting task.'**
  String get completedTeamMeetingTask;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String minutesAgo(Object count);

  /// No description provided for @hourAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hour ago'**
  String hourAgo(Object count);

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You are all caught up. New task updates and reminders will appear here.'**
  String get allCaughtUp;

  /// No description provided for @taskDetails.
  ///
  /// In en, this message translates to:
  /// **'Task Details'**
  String get taskDetails;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @noDescriptionAdded.
  ///
  /// In en, this message translates to:
  /// **'No description added.'**
  String get noDescriptionAdded;

  /// No description provided for @scheduledDate.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Date'**
  String get scheduledDate;

  /// No description provided for @deleteTask.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get deleteTask;

  /// No description provided for @deleteTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Task'**
  String get deleteTaskTitle;

  /// No description provided for @deleteTaskConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this task? This action cannot be undone.'**
  String get deleteTaskConfirmation;

  /// No description provided for @areYouSureDeleteTask.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this task? This action cannot be undone.'**
  String get areYouSureDeleteTask;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @noUserDataFound.
  ///
  /// In en, this message translates to:
  /// **'No user data found'**
  String get noUserDataFound;

  /// No description provided for @nameCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get nameCannotBeEmpty;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @profilePhotoPickerWillBeAddedLater.
  ///
  /// In en, this message translates to:
  /// **'Profile photo picker will be added later'**
  String get profilePhotoPickerWillBeAddedLater;

  /// No description provided for @changePasswordWillBeAddedLater.
  ///
  /// In en, this message translates to:
  /// **'Change password will be added later'**
  String get changePasswordWillBeAddedLater;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @updateYourAccountPassword.
  ///
  /// In en, this message translates to:
  /// **'Update your account password'**
  String get updateYourAccountPassword;

  /// No description provided for @splashTaskFlow.
  ///
  /// In en, this message translates to:
  /// **'TaskFlow'**
  String get splashTaskFlow;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Plan. Focus. Get Things Done.'**
  String get splashTagline;

  /// No description provided for @trackYourProductivity.
  ///
  /// In en, this message translates to:
  /// **'Track your productivity'**
  String get trackYourProductivity;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @totalTasks.
  ///
  /// In en, this message translates to:
  /// **'Total Tasks'**
  String get totalTasks;

  /// No description provided for @completionOverview.
  ///
  /// In en, this message translates to:
  /// **'Completion Overview'**
  String get completionOverview;

  /// No description provided for @weeklyProductivity.
  ///
  /// In en, this message translates to:
  /// **'Weekly Productivity'**
  String get weeklyProductivity;

  /// No description provided for @tasksCompletedPerDay.
  ///
  /// In en, this message translates to:
  /// **'Tasks completed per day'**
  String get tasksCompletedPerDay;

  /// No description provided for @noCategoryDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No category data available'**
  String get noCategoryDataAvailable;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @mostProductive.
  ///
  /// In en, this message translates to:
  /// **'Most Productive'**
  String get mostProductive;

  /// No description provided for @topCategory.
  ///
  /// In en, this message translates to:
  /// **'Top Category'**
  String get topCategory;

  /// No description provided for @completion.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get completion;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @noTasksYet.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get noTasksYet;

  /// Message shown when a category has no tasks
  ///
  /// In en, this message translates to:
  /// **'No tasks in {categoryName}'**
  String categoryNoTasks(String categoryName);

  /// No description provided for @categoryTasksDescription.
  ///
  /// In en, this message translates to:
  /// **'Tasks assigned to this category will appear here.'**
  String get categoryTasksDescription;

  /// No description provided for @categoryDateTimeSeparator.
  ///
  /// In en, this message translates to:
  /// **' • '**
  String get categoryDateTimeSeparator;

  /// No description provided for @noCompletedTasks.
  ///
  /// In en, this message translates to:
  /// **'No completed tasks'**
  String get noCompletedTasks;

  /// No description provided for @createTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Task'**
  String get createTaskTitle;

  /// No description provided for @editTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTaskTitle;

  /// No description provided for @taskTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Task Title'**
  String get taskTitleLabel;

  /// No description provided for @taskTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter task title'**
  String get taskTitleHint;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Add task description (optional)'**
  String get descriptionHint;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @taskTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a task title'**
  String get taskTitleRequired;

  /// No description provided for @categoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get categoryRequired;

  /// No description provided for @dateRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get dateRequired;

  /// No description provided for @timeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a time'**
  String get timeRequired;

  /// No description provided for @addCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategoryTitle;

  /// No description provided for @categoryNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryNameLabel;

  /// No description provided for @categoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter category name'**
  String get categoryNameHint;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @enableOrDisableAllNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable or disable all notifications'**
  String get enableOrDisableAllNotifications;

  /// No description provided for @taskReminders.
  ///
  /// In en, this message translates to:
  /// **'Task Reminders'**
  String get taskReminders;

  /// No description provided for @receiveRemindersBeforeTasks.
  ///
  /// In en, this message translates to:
  /// **'Receive reminders before your tasks'**
  String get receiveRemindersBeforeTasks;

  /// No description provided for @reminderBeforeTask.
  ///
  /// In en, this message translates to:
  /// **'Reminder Before Task'**
  String get reminderBeforeTask;

  /// No description provided for @oneHourBefore.
  ///
  /// In en, this message translates to:
  /// **'1 hour before'**
  String get oneHourBefore;

  /// Shows how many minutes before a task the reminder will be sent
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes before'**
  String minutesBefore(int minutes);

  /// No description provided for @focusNotifications.
  ///
  /// In en, this message translates to:
  /// **'Focus Notifications'**
  String get focusNotifications;

  /// No description provided for @receiveFocusSessionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Receive notifications related to focus sessions'**
  String get receiveFocusSessionNotifications;

  /// No description provided for @focusSessionFinished.
  ///
  /// In en, this message translates to:
  /// **'Focus Session Finished'**
  String get focusSessionFinished;

  /// No description provided for @notifyWhenFocusSessionEnds.
  ///
  /// In en, this message translates to:
  /// **'Notify me when a focus session ends'**
  String get notifyWhenFocusSessionEnds;

  /// No description provided for @breakStarted.
  ///
  /// In en, this message translates to:
  /// **'Break Started'**
  String get breakStarted;

  /// No description provided for @notifyWhenBreakStarts.
  ///
  /// In en, this message translates to:
  /// **'Notify me when a break starts'**
  String get notifyWhenBreakStarts;

  /// No description provided for @breakFinished.
  ///
  /// In en, this message translates to:
  /// **'Break Finished'**
  String get breakFinished;

  /// No description provided for @notifyWhenBreakEnds.
  ///
  /// In en, this message translates to:
  /// **'Notify me when a break ends'**
  String get notifyWhenBreakEnds;

  /// No description provided for @notificationSettingsInfo.
  ///
  /// In en, this message translates to:
  /// **'When notifications are enabled, TaskFlow can send task reminders and focus notifications based on your preferences.'**
  String get notificationSettingsInfo;

  /// No description provided for @focusSessionFinishedNotification.
  ///
  /// In en, this message translates to:
  /// **'Focus Session Completed'**
  String get focusSessionFinishedNotification;

  /// No description provided for @focusSessionFinishedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your focus session has finished.'**
  String get focusSessionFinishedMessage;

  /// No description provided for @breakStartedNotification.
  ///
  /// In en, this message translates to:
  /// **'Break Started'**
  String get breakStartedNotification;

  /// No description provided for @breakStartedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your break has started. Take some time to recharge.'**
  String get breakStartedMessage;

  /// No description provided for @breakFinishedNotification.
  ///
  /// In en, this message translates to:
  /// **'Break Finished'**
  String get breakFinishedNotification;

  /// No description provided for @breakFinishedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your break has finished. Ready to focus again?'**
  String get breakFinishedMessage;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @notificationTaskCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Completed'**
  String get notificationTaskCompletedTitle;

  /// No description provided for @notificationTaskCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'You completed a task. Great job!'**
  String get notificationTaskCompletedBody;

  /// No description provided for @notificationTaskOverdueTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Overdue'**
  String get notificationTaskOverdueTitle;

  /// No description provided for @notificationTaskOverdueBody.
  ///
  /// In en, this message translates to:
  /// **'You have an overdue task.'**
  String get notificationTaskOverdueBody;

  /// No description provided for @notificationTaskOverdueBodyWithTask.
  ///
  /// In en, this message translates to:
  /// **'{taskTitle} is overdue.'**
  String notificationTaskOverdueBodyWithTask(Object taskTitle);

  /// No description provided for @notificationTaskReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Reminder'**
  String get notificationTaskReminderTitle;

  /// No description provided for @notificationTaskReminderBody.
  ///
  /// In en, this message translates to:
  /// **'You have a task coming up soon.'**
  String get notificationTaskReminderBody;

  /// No description provided for @notificationTaskReminderBodyWithTask.
  ///
  /// In en, this message translates to:
  /// **'{taskTitle} is coming up soon.'**
  String notificationTaskReminderBodyWithTask(Object taskTitle);

  /// No description provided for @notificationFocusSessionFinishedTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus Session Finished'**
  String get notificationFocusSessionFinishedTitle;

  /// No description provided for @notificationFocusSessionFinishedBody.
  ///
  /// In en, this message translates to:
  /// **'Great work! Your focus session is complete.'**
  String get notificationFocusSessionFinishedBody;

  /// No description provided for @notificationBreakStartedTitle.
  ///
  /// In en, this message translates to:
  /// **'Break Time'**
  String get notificationBreakStartedTitle;

  /// No description provided for @notificationBreakStartedBody.
  ///
  /// In en, this message translates to:
  /// **'Time to take a short break.'**
  String get notificationBreakStartedBody;

  /// No description provided for @notificationBreakFinishedTitle.
  ///
  /// In en, this message translates to:
  /// **'Break Finished'**
  String get notificationBreakFinishedTitle;

  /// No description provided for @notificationBreakFinishedBody.
  ///
  /// In en, this message translates to:
  /// **'Your break is over. Ready to focus again?'**
  String get notificationBreakFinishedBody;

  /// No description provided for @notificationDailyAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to get things done?'**
  String get notificationDailyAppTitle;

  /// No description provided for @notificationDailyAppBody.
  ///
  /// In en, this message translates to:
  /// **'Come manage your tasks and make today productive.'**
  String get notificationDailyAppBody;

  /// No description provided for @notificationStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep your streak alive 🔥'**
  String get notificationStreakTitle;

  /// No description provided for @notificationStreakBody.
  ///
  /// In en, this message translates to:
  /// **'Keep going and protect your TaskFlow streak! 🔥'**
  String get notificationStreakBody;

  /// No description provided for @dailyAppNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to get things done?'**
  String get dailyAppNotificationTitle;

  /// No description provided for @dailyAppNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Come manage your tasks and make today productive.'**
  String get dailyAppNotificationBody;

  /// No description provided for @streakNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep your streak alive 🔥'**
  String get streakNotificationTitle;

  /// No description provided for @streakNotificationBodyFirstDay.
  ///
  /// In en, this message translates to:
  /// **'Keep going! Start building your TaskFlow streak.'**
  String get streakNotificationBodyFirstDay;

  /// No description provided for @streakNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'You are on a {streak}-day streak. Keep it going! 🔥'**
  String streakNotificationBody(int streak);

  /// No description provided for @habitsIntro.
  ///
  /// In en, this message translates to:
  /// **'Build healthy routines, track your progress, and stay consistent with your daily goals.'**
  String get habitsIntro;

  /// No description provided for @habitsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Habits are coming soon'**
  String get habitsComingSoon;

  /// No description provided for @habitsComingSoonDescription.
  ///
  /// In en, this message translates to:
  /// **'We are working on a simple and powerful habit tracking experience to help you build better routines.'**
  String get habitsComingSoonDescription;

  /// No description provided for @privacyYourData.
  ///
  /// In en, this message translates to:
  /// **'Your Data'**
  String get privacyYourData;

  /// No description provided for @privacyYourDataDescription.
  ///
  /// In en, this message translates to:
  /// **'TaskFlow is designed to help you manage your tasks and productivity while keeping your personal information under your control.'**
  String get privacyYourDataDescription;

  /// No description provided for @privacyDataStorage.
  ///
  /// In en, this message translates to:
  /// **'Data Storage'**
  String get privacyDataStorage;

  /// No description provided for @privacyDataStorageDescription.
  ///
  /// In en, this message translates to:
  /// **'Your app settings and locally stored information are kept on your device using local storage.'**
  String get privacyDataStorageDescription;

  /// No description provided for @privacyNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get privacyNotifications;

  /// No description provided for @privacyNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'You can control notifications, reminders, sounds, and focus alerts from the Settings section.'**
  String get privacyNotificationsDescription;

  /// No description provided for @privacyYourControl.
  ///
  /// In en, this message translates to:
  /// **'Your Control'**
  String get privacyYourControl;

  /// No description provided for @privacyYourControlDescription.
  ///
  /// In en, this message translates to:
  /// **'You can change your preferences at any time, including language, appearance, sounds, and notification settings.'**
  String get privacyYourControlDescription;

  /// No description provided for @termsIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get termsIntroduction;

  /// No description provided for @termsIntroductionDescription.
  ///
  /// In en, this message translates to:
  /// **'By using TaskFlow, you agree to use the application responsibly and in accordance with these terms.'**
  String get termsIntroductionDescription;

  /// No description provided for @termsUserResponsibilities.
  ///
  /// In en, this message translates to:
  /// **'User Responsibilities'**
  String get termsUserResponsibilities;

  /// No description provided for @termsUserResponsibilitiesDescription.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for the information and tasks you create in TaskFlow and for keeping your account information secure.'**
  String get termsUserResponsibilitiesDescription;

  /// No description provided for @termsUsingTaskFlow.
  ///
  /// In en, this message translates to:
  /// **'Using TaskFlow'**
  String get termsUsingTaskFlow;

  /// No description provided for @termsUsingTaskFlowDescription.
  ///
  /// In en, this message translates to:
  /// **'TaskFlow is provided as a productivity and task-management tool. You should use its features responsibly and avoid using the application for unlawful purposes.'**
  String get termsUsingTaskFlowDescription;

  /// No description provided for @termsChanges.
  ///
  /// In en, this message translates to:
  /// **'Changes to These Terms'**
  String get termsChanges;

  /// No description provided for @termsChangesDescription.
  ///
  /// In en, this message translates to:
  /// **'These terms may be updated in the future as TaskFlow evolves. Important changes will be reflected in the application.'**
  String get termsChangesDescription;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: August 2026'**
  String get lastUpdated;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get deleteCategoryTitle;

  /// No description provided for @deleteCategoryMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{categoryName}\"?'**
  String deleteCategoryMessage(Object categoryName);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
