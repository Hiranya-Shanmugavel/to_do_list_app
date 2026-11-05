import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';

/// Authentication Service
///
/// Wraps [FirebaseAuth] to handle Email/Password and Anonymous login.
/// Provides a fallback mode if Firebase credentials have not yet been configured.
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  final FirebaseAuth? _auth;

  // StreamController for demo/offline fallback mode
  final StreamController<User?> _mockAuthController =
      StreamController<User?>.broadcast();
  User? _mockUser;

  AuthService._internal()
      : _auth = DefaultFirebaseOptions.isConfigured
            ? FirebaseAuth.instance
            : null {
    // Start demo mode in signed-out state
    if (_auth == null) {
      _mockAuthController.add(null);
    }
  }

  /// Active stream of authentication state changes
  Stream<User?> get authStateChanges {
    if (_auth != null) {
      return _auth!.authStateChanges();
    }
    return _mockAuthController.stream;
  }

  /// Currently logged in user
  User? get currentUser {
    if (_auth != null) {
      return _auth!.currentUser;
    }
    return _mockUser;
  }

  /// Sign in with Email and Password
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    if (_auth != null) {
      return await _auth!.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    }

    // Mock sign in for demo mode
    _mockUser = null; // In demo mode, we simulate successful sign-in
    _mockAuthController.add(_mockUser);
    return null;
  }

  /// Sign up with Email and Password
  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    if (_auth != null) {
      return await _auth!.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    }

    // Mock sign up for demo mode
    return null;
  }

  /// Guest / Anonymous sign in
  Future<UserCredential?> signInAnonymously() async {
    if (_auth != null) {
      return await _auth!.signInAnonymously();
    }
    return null;
  }

  /// Sign out
  Future<void> signOut() async {
    if (_auth != null) {
      await _auth!.signOut();
    } else {
      _mockUser = null;
      _mockAuthController.add(null);
    }
  }
}
