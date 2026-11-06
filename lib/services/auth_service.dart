import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';

/// Authentication Service
///
/// Wraps [FirebaseAuth] to handle Email/Password and Anonymous login.
/// Provides an in-memory fallback mode if Firebase credentials have not yet been configured
/// or during automated widget testing.
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  FirebaseAuth? get _auth {
    if (DefaultFirebaseOptions.isConfigured && Firebase.apps.isNotEmpty) {
      try {
        return FirebaseAuth.instance;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  // StreamController for demo/offline fallback mode
  final StreamController<User?> _mockAuthController =
      StreamController<User?>.broadcast();
  User? _mockUser;

  AuthService._internal() {
    // Start demo mode in signed-out state if Firebase is not active
    if (!DefaultFirebaseOptions.isConfigured || Firebase.apps.isEmpty) {
      _mockAuthController.add(null);
    }
  }

  /// Active stream of authentication state changes
  Stream<User?> get authStateChanges {
    final auth = _auth;
    if (auth != null) {
      return auth.authStateChanges();
    }
    return _mockAuthController.stream;
  }

  /// Currently logged in user
  User? get currentUser {
    final auth = _auth;
    if (auth != null) {
      return auth.currentUser;
    }
    return _mockUser;
  }

  /// Sign in with Email and Password
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    final auth = _auth;
    if (auth != null) {
      return await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    }

    // Mock sign in for demo mode
    _mockUser = null;
    _mockAuthController.add(_mockUser);
    return null;
  }

  /// Sign up with Email and Password
  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    final auth = _auth;
    if (auth != null) {
      return await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    }

    // Mock sign up for demo mode
    return null;
  }

  /// Guest / Anonymous sign in
  Future<UserCredential?> signInAnonymously() async {
    final auth = _auth;
    if (auth != null) {
      return await auth.signInAnonymously();
    }
    return null;
  }

  /// Sign out
  Future<void> signOut() async {
    final auth = _auth;
    if (auth != null) {
      await auth.signOut();
    } else {
      _mockUser = null;
      _mockAuthController.add(null);
    }
  }
}
