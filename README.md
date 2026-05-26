# Smart Student Planner

This is an app built using flutter for university students who want a way to manage their academic tasks, track their various study sessions using a Pomodoro timer, and help them stay on top of their deadlines. Built as part of the LDC6004M Mobile Application Development module at York St John University.

---

## App purpose and target users

The app is specifically designed and built for university students who are looking for a simple and reliable tool to help them work and organise their various academic workloads. You can create task that are tied to modules, set deadlines ahead with varying priority levels, you can also track completed task, and use the built in Pomodoro timer for stay focused or for study sessions. The main target users are University students that are juggling different modules that have overlapping deadlines.

---

## Features

- Authentication - The app features a local account creation and login with email and password validation
- Dashboard - this has a personalised greeting to the user, weekly progress ring, priority focus tasks, and upcoming tasks with deadlines
- Task management - the app features the ability to add, edit, delete, mark complete or incomplete, and search tasks
- Pomodoro timer - 25-minute focus / 5-minute break cycle with session tracking
- Settings - Dark mode toggle, app theme selection (Light / Dark / System), notification preferences
- Profile - Edit name, course, and profile photo
- Local persistence - All data stored on-device using SQLite; so theres no need for internet connection
- Material 3 theming - Dynamic wallpaper colour on phones with Android 12 and above, plus full dark mode support

---

## Tech stack

| Tool | Version |
|---|---|
| Flutter | 3.44.0 |
| Dart | 3.12.0 |
| sqflite | 2.4.2+1 |
| provider | 6.1.5+1 |
| shared_preferences | 2.5.5 |
| dynamic_color | 1.8.1 |
| flutter_svg | 2.3.0 |
| Android SDK | API 35 (Android 15) |
| Test device | Samsung Galaxy A55 (Android 16) |

---

## Architecture

The app follows the MVC (Model-View-Controller) architecture:

```
lib/
├── main.dart                        # This is the entry point of the app, providers, theme setup
├── controllers/
│   ├── auth_controller.dart         # This manages login, signup, session management
│   ├── task_controller.dart         # For creating tasks, CRUD operations, search, filter
│   ├── timer_controller.dart        # Pomodoro countdown logic
│   └── theme_controller.dart        # Dark mode, seed colour, dynamic colour
├── models/
│   ├── task.dart                    # Task data class, toMap/fromMap/copyWith
│   ├── user.dart                    # User data class
│   └── database_helper.dart         # SQLite singleton, all CRUD queries
└── views/
    ├── screens/
    │   ├── splash_screen.dart        # Launch screen, auth routing
    │   ├── landing_screen.dart       # Welcome screen, create/login options
    │   ├── login_screen.dart         # Email + password login
    │   ├── signup_screen.dart        # Account creation
    │   ├── main_shell.dart           # Bottom navbar shell (4 tabs)
    │   ├── dashboard_screen.dart     # Home - progress, priority focus, upcoming
    │   ├── tasks_screen.dart         # Full task list, search, filter
    │   ├── timer_screen.dart         # Pomodoro timer with custom dial
    │   ├── settings_screen.dart      # Theme, notifications, account settings
    │   ├── profile_screen.dart       # Edit profile details
    │   └── new_task_screen.dart      # Add and edit task form
    └── widgets/
        └── (reusable widget components)
```

---

## Prerequisites

Before you run the project, ensure you have the following installed:

- Flutter SDK 3.44.0 or above (https://docs.flutter.dev/get-started/install)
- Android Studio (https://developer.android.com/studio) or VS Code (https://code.visualstudio.com/) with the Flutter extension
- Android SDK - API level 21 or above (API 35 is recommended)
- A physical Android device or Android emulator

You can verify your Flutter installation by running this command:

```bash
flutter doctor
```

All items should show a green checkmark before proceeding.

---

## Installation and setup

### 1. Clone the repository

```bash
git clone https://github.com/tobex434/Smart-Student-Planner.git
cd Smart-Student-Planner
```

### 2. To install dependencies run 

```bash
flutter pub get
```

### 3. Connect a device or start an emulator

Physical device:
- Enable Developer Options on your Android device
- Enable USB Debugging
- Connect via USB
- Run `flutter devices` to confirm the device is detected

Emulator:
- Open Android Studio > Device Manager > Create Device
- Select a device with API level 21 or above
- Start the emulator

### 4. Run the app

```bash
flutter run
```

For a release build:

```bash
flutter build apk --release
```

The APK will be exported to this directory `build/app/outputs/flutter-apk/app-release.apk`

---

## Environment notes

- The app uses sqflite for local SQLite storage. Theres no need for database setup; the database and tables are created automatically on first launch.
- The app uses dynamic_color to read the users wallpaper-based colour palettes. This is only active on Android 12 devices (API 31) and above. On older devices or iOS, the app falls back to the seed colour (#1565C0) that we set in the main file.
- No API keys, environment variables, or .env files are required.
- Internet connection is not required. All data is stored locally on the device.

---

## First launch flow

```
App opens -> Splash screen loads
         -> Checks SharedPreferences for existing session
         -> Logged in?  Yes -> Dashboard
                       No  -> Has any account in SQLite?
                             Yes -> Login screen
                             No  -> Landing screen (create account)
```

---

## Known limitations

- No Firebase sync - the app is fully offline. A Firebase branch is planned for cloud backup and cross-device sync (feature/firebase-sync).
- No data export — student cannot back up or export their task list
- Schema migration - if the database schema changes between versions, users must uninstall and reinstall the app. A migration strategy using sqflite's onUpgrade callback would be implemented in a production version.
- Dynamic colour on iOS - the dynamic_color package does not support iOS wallpaper-based colour generation. iOS users receive the seed colour fallback only.

---

## Future enhancements

- Firebase Authentication and Firestore sync (feature/firebase-sync branch)
- Push notifications for task deadlines using flutter_local_notifications
- Widget (home screen) showing today's tasks
- Google Calendar integration to sync upcoming tasks to the users calendar 
- Onboarding flow for new users a guided walkthrough of the app features on first launch

---

## Version control

The full development history is available at:
https://github.com/tobex434/Smart-Student-Planner

Commits follow a feat: / fix: / refactor: prefix convention to clearly document development progress.

---

## References

- Flutter Team (2025) Flutter documentation [Online]. Available at: https://docs.flutter.dev (Accessed: 21 May 2026)
- Dart Team (2025) Effective Dart: Style [Online]. Available at: https://dart.dev/effective-dart/style (Accessed: 21 May 2026)
- Tekartia (2024) sqflite [Online]. Available at: https://pub.dev/packages/sqflite (Accessed: 21 May 2026)
- material-foundation (2024) dynamic_color [Online]. Available at: https://pub.dev/packages/dynamic_color (Accessed: 21 May 2026)
