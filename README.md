# 📅 Personal Daily Planner & To-Do App

A clean, modern, and cross-platform **Personal Daily Planner** built with **Flutter** and **Material 3**. Designed to run seamlessly across **laptop / desktop browsers and mobile devices**, featuring real-time **Cloud Firestore** synchronization, **Firebase Authentication**, responsive layout adaptation, and automated **GitHub Actions CI/CD** cloud deployment.

---

## ✨ Features & Architecture

| Feature | Implementation Details |
|---|---|
| 🖥️ **Responsive Laptop & Mobile UI** | Uses `ResponsiveContainer` (centered, constrained `768px` max-width on desktop; adaptive full-width on mobile viewports). |
| 🔐 **Firebase Authentication** | Secure Email/Password registration and sign-in, with a quick one-click **"Continue as Guest"** option. |
| ☁️ **Cloud Firestore Real-Time Sync** | Automatically synchronizes tasks across all your devices using real-time streams (`.snapshots()`). |
| 🔒 **Private, User-Scoped Storage** | Each user's tasks are stored securely under `/users/{userId}/tasks/{taskId}`. |
| 🔄 **Offline Persistence** | Firestore caching ensures tasks remain saved after closing and reopening the app, even without an active internet connection. |
| 📝 **Add Tasks with Validation** | Rounded text field with whitespace trim validation and Enter key submission. |
| 🔘 **Task Checkbox & Strikethrough** | Checkbox toggles task completion status with smooth `TextDecoration.lineThrough` animation. |
| 🗑️ **Swipe-to-Delete (Dismissible)** | Swipe left or right on any task to delete, with an animated red background and an interactive **Undo** action. |
| 📊 **Dynamic Remaining Counter & Progress** | Real-time task counter, completion percentage badge, and visual progress bar. |
| 👋 **Personal Daily Header** | Displays dynamic greeting ("Good morning / afternoon"), today's formatted date, user profile tag, and sign out dialog. |
| 🚀 **GitHub Actions Cloud CI/CD** | Builds Flutter Web in the cloud on every `git push` to `main` and publishes automatically to **GitHub Pages**. |

---

## 📂 Project Structure

```
to_do_list_app/
├── .github/
│   └── workflows/
│       └── deploy.yml                 # GitHub Actions CI/CD for Flutter Web to GitHub Pages
├── lib/
│   ├── main.dart                      # App entry point, Firebase init, Auth state stream
│   ├── firebase_options.dart          # Firebase configuration template & safety check
│   ├── models/
│   │   └── task.dart                  # Enhanced Task model with Firestore toMap / fromMap
│   ├── screens/
│   │   ├── auth_screen.dart           # Responsive Email/Password & Guest Auth Screen
│   │   └── todo_home_screen.dart      # Real-time Daily Planner with Firestore StreamBuilder
│   ├── services/
│   │   ├── auth_service.dart          # FirebaseAuth wrapper with offline fallback
│   │   └── task_service.dart          # Cloud Firestore CRUD & real-time streams
│   └── widgets/
│       ├── empty_state_view.dart      # Friendly message shown when list is empty
│       ├── planner_header.dart        # Greeting, formatted date, user tag & sign out
│       ├── responsive_container.dart  # Adaptive container for mobile and desktop screens
│       ├── task_input_field.dart      # Text field, Add button & empty validation
│       ├── task_summary_card.dart     # Dynamic remaining tasks counter & progress bar
│       └── task_tile.dart             # Dismissible item tile with Checkbox & strikethrough
├── test/
│   └── widget_test.dart               # Complete Flutter test suite for Auth & Planner
├── web/                               # Web support files (index.html, manifest.json)
├── android/                           # Android Gradle configuration & manifest
├── pubspec.yaml                       # Flutter project dependencies & metadata
├── analysis_options.yaml              # Dart linting & formatting rules
└── README.md                          # Project documentation
```

---

## 🚀 Cloud Web Deployment (No Local Flutter Required!)

Because Flutter SDK is not installed on your local machine, a **GitHub Actions CI/CD pipeline** is pre-configured in `.github/workflows/deploy.yml`.

### How it Works:
1. Every time you push code to `main`, GitHub runs the workflow automatically on an Ubuntu cloud runner.
2. It fetches dependencies, executes widget tests, and builds the Flutter Web application release.
3. It deploys the compiled website directly to the `gh-pages` branch.

### Enabling GitHub Pages in Your Repository:
1. Go to your GitHub repository: [https://github.com/Hiranya-Shanmugavel/to_do_list_app](https://github.com/Hiranya-Shanmugavel/to_do_list_app).
2. Click **Settings** > **Pages** (under Code and automation in the left sidebar).
3. Under **Build and deployment** > **Source**, select **Deploy from a branch**.
4. Under **Branch**, select `gh-pages` and folder `/ (root)`, then click **Save**.
5. Your live Daily Planner will be available at:
   👉 **`https://Hiranya-Shanmugavel.github.io/to_do_list_app/`**

---

## 🔑 Firebase Setup Guide (Connecting Live Cloud Sync)

The application includes an automatic **Demo Mode**: it runs with in-memory storage right out of the box so you can test immediately without any errors.

To connect live real-time sync across your phone and laptop:

### 1. Create a Firebase Project
1. Go to [console.firebase.google.com](https://console.firebase.google.com/) and click **Add project**.
2. Name your project (e.g., `personal-daily-planner`).

### 2. Enable Authentication
1. Go to **Build** > **Authentication** > **Get Started**.
2. In the **Sign-in method** tab, enable:
   - **Email/Password**
   - **Anonymous** (for Guest mode)

### 3. Enable Cloud Firestore
1. Go to **Build** > **Firestore Database** > **Create database**.
2. Choose **Start in production mode**.
3. Under the **Rules** tab, paste the following security rules so users can only access their own private tasks:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId}/tasks/{taskId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```
4. Click **Publish**.

### 4. Register Web App & Add Keys
1. In the Firebase Project Overview, click the **Web icon (`</>`)** to register a web app.
2. Copy the `firebaseConfig` keys into [lib/firebase_options.dart](file:///c:/Users/user/Documents/GitHub/to_do_list_app/lib/firebase_options.dart).

---

## 💡 Running Locally (When Flutter SDK is Installed)

```powershell
# 1. Fetch dependencies
flutter pub get

# 2. Run widget tests
flutter test

# 3. Launch on Chrome (Web)
flutter run -d chrome

# 4. Launch on Android Emulator or Device
flutter run
```

---

## 📄 License
This project is open-source under the MIT License and submitted as part of **InternCircle Project 03**.
