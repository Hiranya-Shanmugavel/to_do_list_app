import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/auth_screen.dart';
import 'screens/todo_home_screen.dart';
import 'services/auth_service.dart';

/// Entry point of the Personal Daily Planner Flutter application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Safely initialize Firebase if valid credentials have been configured
  if (DefaultFirebaseOptions.isConfigured) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      debugPrint('Firebase initialization notice: $e');
    }
  }

  runApp(const TodoListApp());
}

/// Root Application Widget
///
/// Configures the modern Material 3 theme, pleasant Indigo color scheme,
/// and streams authentication state to show either [TodoHomeScreen] or [AuthScreen].
class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Primary brand color: Modern Vibrant Indigo
    const primaryColor = Color(0xFF4F46E5);

    return MaterialApp(
      title: 'Personal Daily Planner',
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
      home: StreamBuilder<User?>(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          // In demo fallback mode or when user is authenticated
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Color(0xFFF8FAFC),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // If user is logged in, show the Personal Daily Planner
          if (snapshot.hasData && snapshot.data != null) {
            return const TodoHomeScreen();
          }

          // If not logged in, present the Authentication Screen
          return const AuthScreen();
        },
      ),
    );
  }
}
