import 'package:flutter/material.dart';
import 'screens/todo_home_screen.dart';

/// Entry point of the Flutter application
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TodoListApp());
}

/// Root Application Widget
///
/// Configures the modern Material 3 theme, pleasant Indigo color scheme,
/// and sets the home screen to [TodoHomeScreen].
class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Primary brand color: Modern Vibrant Indigo
    const primaryColor = Color(0xFF4F46E5);

    return MaterialApp(
      title: 'To-Do List - InternCircle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF0F172A),
          centerTitle: false,
        ),
        fontFamily: null, // Uses default clean system font
      ),
      home: const TodoHomeScreen(),
    );
  }
}
