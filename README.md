# 📝 InternCircle Project 03 – To-Do List App

A clean, modern, and beginner-friendly To-Do List application built with **Flutter** and **Material 3**. This project was crafted for **InternCircle Project 03**, demonstrating fundamental Flutter concepts such as state management with `StatefulWidget`, dynamic UI rendering with `ListView.builder`, gesture handling with the `Dismissible` widget, dynamic counters, and input validation.

---

## 📱 Features

| # | Requirement | Implementation Details |
|---|-------------|------------------------|
| 1 | **Clean & Attractive UI** | Modern Material 3 styling with Indigo/Violet palette (`#4F46E5`), soft card elevations, and rounded corners. |
| 2 | **Task Text Field** | Clean input field with icon and placeholder text for quick task entry. |
| 3 | **Add Button** | Elevated "Add" button with an icon that inserts the task at the top of the list. Also supports pressing `Enter` on keyboard. |
| 4 | **ListView.builder** | High-performance, lazily rendered task list using `ListView.builder` with bouncy physics. |
| 5 | **Task Checkbox** | Interactive checkbox on each task card to toggle completion status. |
| 6 | **Strikethrough Effect** | Completed tasks show `TextDecoration.lineThrough` and a dimmed text color for visual clarity. |
| 7 | **Swipe-to-Delete (Dismissible)** | Swipe left or right on any task to delete it using the `Dismissible` widget, featuring an animated red background and an "Undo" SnackBar. |
| 8 | **Dynamic Remaining Counter** | Real-time remaining tasks counter and visual progress bar dynamically computed via `tasks.where((t) => !t.isCompleted).length`. |
| 9 | **Friendly Empty State** | When all tasks are cleared, displays an encouraging illustration and friendly message (`EmptyStateView`). |
| 10 | **StatefulWidget & Data Model** | Pure Flutter state management using `StatefulWidget` and a dedicated `Task` data model class. |
| 11 | **Pleasant Color Combination** | Indigo (`#4F46E5`), Slate backgrounds (`#F8FAFC`), crisp white cards, and amber warning alerts. |
| 12 | **Input Validation** | Validates against empty or whitespace-only inputs, displaying a floating feedback SnackBar. |
| 13 | **Beginner-Friendly Code** | Fully documented with explanatory comments throughout every file. |

---

## 📂 Project Structure

```
todo_list_app/
├── lib/
│   ├── main.dart                      # Application entry point & ThemeData configuration
│   ├── models/
│   │   └── task.dart                  # Task model (id, title, isCompleted, createdAt)
│   ├── screens/
│   │   └── todo_home_screen.dart      # Main StatefulWidget managing task list state & UI
│   └── widgets/
│       ├── empty_state_view.dart      # Friendly message shown when no tasks exist
│       ├── task_input_field.dart      # Text field, Add button & empty validation
│       ├── task_summary_card.dart     # Dynamic remaining tasks counter & progress bar
│       └── task_tile.dart             # Dismissible item tile with Checkbox & strikethrough
├── test/
│   └── widget_test.dart               # Complete Flutter widget test suite
├── web/                               # Web support files (index.html, manifest.json)
├── android/                           # Android Gradle configuration & manifest
├── pubspec.yaml                       # Flutter project dependencies & metadata
├── analysis_options.yaml              # Dart linting & formatting rules
└── README.md                          # Project documentation
```

---

## 🛠️ Key Flutter Concepts Demonstrated

### 1. Simple Data Model (`lib/models/task.dart`)
Each task has an `id`, `title`, `isCompleted` boolean flag, and `createdAt` timestamp:
```dart
class Task {
  final String id;
  String title;
  bool isCompleted;
  final DateTime createdAt;

  Task({required this.id, required this.title, this.isCompleted = false});

  void toggleCompleted() {
    isCompleted = !isCompleted;
  }
}
```

### 2. State Management with `StatefulWidget` & `setState`
The `_TodoHomeScreenState` maintains the list of tasks. When tasks are added, toggled, or deleted, `setState()` triggers a re-render of the widget tree:
```dart
void _toggleTaskCompletion(Task task) {
  setState(() {
    task.toggleCompleted();
  });
}
```

### 3. Dynamic Calculation of Remaining Tasks
Calculated cleanly using Dart's `Iterable.where`:
```dart
int get remainingTasksCount => _tasks.where((task) => !task.isCompleted).length;
```

### 4. Swipe to Delete with `Dismissible`
Wraps each task card with horizontal swipe detection, custom red delete background, and provides an "Undo" action:
```dart
Dismissible(
  key: ValueKey(task.id),
  direction: DismissDirection.horizontal,
  background: buildDismissBackground(alignment: Alignment.centerLeft),
  secondaryBackground: buildDismissBackground(alignment: Alignment.centerRight),
  onDismissed: (direction) => _deleteTask(task),
  child: ...
)
```

### 5. Input Validation
Prevents empty or whitespace-only submissions:
```dart
if (enteredText.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Please enter a task before adding!')),
  );
  return;
}
```

---

## 🚀 How to Run the App

### Prerequisites
1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.0.0 or higher).
2. Set up an emulator (Android Studio) or use Google Chrome for web testing.
3. Ensure Flutter is added to your system `PATH`. Run `flutter doctor` in your terminal to verify.

### Running Steps

1. **Open Terminal / Command Prompt** in the project directory:
   ```bash
   cd c:\Users\user\Documents\GitHub\to_do_list_app
   ```

2. **Fetch Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run on Connected Device or Emulator**:
   ```bash
   flutter run
   ```

4. **Run on Chrome (Web)**:
   ```bash
   flutter run -d chrome
   ```

5. **Run Tests**:
   ```bash
   flutter test
   ```

---

## 💡 Running in VS Code or Android Studio

1. **VS Code**:
   - Open the folder in VS Code (`File` > `Open Folder...`).
   - Install the **Flutter** extension.
   - Press `F5` or click `Run` > `Start Debugging`.

2. **Android Studio**:
   - Select `Open an Existing Project` and choose this folder.
   - Select your target device / emulator in the toolbar.
   - Click the green **Run ▶** button.

---

## 📄 License
This project is submitted for educational purposes as part of the **InternCircle Flutter Internship Program (Project 03)**.
