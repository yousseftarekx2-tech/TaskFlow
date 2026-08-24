# TaskFlow 📋

**TaskFlow** is a modern and intuitive task management application built with **Flutter** and **Dart**. It helps users organize their daily tasks, manage priorities and categories, track progress, and improve productivity through features such as Focus Mode and local notifications.

The application is designed with a clean and responsive user interface, supports **Arabic and English**, and stores application data locally without requiring a backend or internet connection.

---

## ✨ Features

### 📝 Task Management

* Create new tasks
* Edit existing tasks
* Delete tasks
* Mark tasks as completed
* Set task priorities
* Assign tasks to categories
* View and manage tasks by category
* Track today's progress

### 🗂️ Categories

* Create custom categories
* Edit and delete categories
* Organize tasks by category
* View tasks belonging to a specific category

### 📅 Calendar

* Browse tasks by date
* Navigate between months
* Localized weekday and month names
* Arabic and English calendar support

### ⏱️ Focus Mode

* Focus timer for productive work sessions
* Pomodoro-style workflow
* Track focus sessions
* Designed to help users maintain concentration

### 🔔 Local Notifications

* Task reminder notifications
* Scheduled local notifications
* Notification channels
* Timezone-aware scheduling

### 📊 Statistics

* Track completed tasks
* Monitor productivity
* View task progress and statistics

### 👤 User & Authentication

* Local user registration
* Local login
* User profile
* Local authentication flow
* Forgot password flow

### ⚙️ Settings

* Change application language
* Arabic 🇪🇬 / English 🇺🇸
* Light / Dark theme
* Manage application preferences

### 🌍 Localization

TaskFlow supports:

* 🇪🇬 Arabic
* 🇺🇸 English
* RTL layout for Arabic
* Localized weekdays
* Localized months
* Localized application content

---

## 🛠️ Tech Stack

| Technology                      | Usage                                         |
| ------------------------------- | --------------------------------------------- |
| **Flutter**                     | Mobile application framework                  |
| **Dart**                        | Programming language                          |
| **flutter_bloc**                | State management                              |
| **go_router**                   | Application navigation                        |
| **SharedPreferences**           | Local data and preferences                    |
| **flutter_local_notifications** | Local notifications                           |
| **timezone**                    | Notification scheduling and timezone handling |
| **Google Fonts**                | Typography                                    |
| **flutter_svg**                 | SVG assets                                    |
| **Gap**                         | UI spacing                                    |

> TaskFlow does **not** depend on a backend, REST API, or external networking service. Application data is handled locally on the device.

---

## 🏗️ Architecture

The project follows a **feature-based architecture** to keep the code organized, maintainable, and scalable.

text
lib/
├── core/
│   ├── constants/
│   ├── routing/
│   ├── services/
│   ├── theme/
│   └── utils/
│
├── features/
│   ├── authentication/
│   ├── calendar/
│   ├── categories/
│   ├── focus/
│   ├── home/
│   ├── notifications/
│   ├── profile/
│   ├── settings/
│   ├── statistics/
│   └── tasks/
│
├── l10n/
│   ├── app_ar.arb
│   └── app_en.arb
│
├── app.dart
└── main.dart


### State Management

TaskFlow uses **BLoC/Cubit** to separate business logic from the presentation layer and manage application state in a predictable way.

Examples include:

* Task state
* Category state
* Authentication state
* Theme state
* Language state
* Focus timer state
* Notification state

---

## 💾 Local Data Storage

TaskFlow is designed as a **local-first application**.

User and application data are stored locally on the device using local storage solutions such as:

* **SharedPreferences**
* Local application services
* Local models and repositories

This allows the application to work without requiring an internet connection or remote server.

---

## 🔔 Notification System

TaskFlow includes a complete local notification system for task reminders.

The notification implementation includes:

* Notification channels
* Scheduled notifications
* Task reminder handling
* Timezone support
* Notification configuration

The notification system works locally on the user's device.

---

## 🎨 UI / UX

The application focuses on providing a clean and consistent user experience through:

* Modern Material UI
* Reusable widgets
* Consistent spacing
* Consistent typography
* Responsive layouts
* Light and Dark themes
* Arabic RTL support
* Clear navigation
* User-friendly task management

---

## 🌐 Localization

TaskFlow uses Flutter's localization system with **ARB files**.

text
lib/l10n/
├── app_ar.arb
└── app_en.arb


Supported languages:

**Arabic 🇪🇬**

* Full RTL support
* Localized interface
* Localized weekdays
* Localized months

**English 🇺🇸**

* Localized interface
* Localized weekdays
* Localized months

The language can be changed from the application settings.

---

## 📱 Application Screens

The application includes multiple screens designed around the complete task management workflow:

* Splash
* Onboarding
* Login
* Sign Up
* Home
* Tasks
* Categories
* Category Tasks
* Calendar
* Focus
* Statistics
* Notifications
* Profile
* Settings

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Android Emulator or a physical Android device

### Installation

Clone the repository:

bash
git clone https://github.com/YOUR_USERNAME/task_flow.git


Navigate to the project directory:

bash
cd task_flow


Install dependencies:

bash
flutter pub get


Run the application:

bash
flutter run


---

## 📦 Main Dependencies

yaml
flutter_bloc:
go_router:
shared_preferences:
flutter_local_notifications:
timezone:


---

## 🔐 Privacy & Data

TaskFlow does not require an online account or remote backend.

Application data is stored locally on the user's device.

No external API or networking layer is required for the core application functionality.

---

## 📸 Screenshots

### Home

*Add application screenshot here.*

### Tasks

*Add application screenshot here.*

### Calendar

*Add application screenshot here.*

### Focus Mode

*Add application screenshot here.*

### Statistics

*Add application screenshot here.*

### Settings

*Add application screenshot here.*

---

## 🎯 Project Goals

TaskFlow was built to demonstrate practical Flutter development skills, including:

* Flutter UI development
* State management with BLoC/Cubit
* Local data persistence
* Local notifications
* Navigation and routing
* Localization
* RTL support
* Theme management
* Reusable components
* Feature-based architecture
* Separation of concerns

---

## 📌 Project Status

**Completed ✅**

TaskFlow is a completed Flutter task management application developed as a practical project to apply modern Flutter development concepts and build a complete mobile application experience.

---

## 👨‍💻 Author

**Youssef Tarek**

Flutter Developer focused on building modern, maintainable, and user-friendly mobile applications.

---

## ⭐ Support

If you like the project, consider giving the repository a ⭐ on GitHub.
