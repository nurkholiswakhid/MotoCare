import 'package:flutter/material.dart';

import '../../core/entities/user.dart';
import '../../core/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  AuthViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<void> checkCurrentUser() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.getCurrentUser();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Validate email format
      if (!_isValidEmail(email)) {
        throw Exception('Format email tidak valid');
      }
      // Validate password
      if (password.isEmpty) {
        throw Exception('Password tidak boleh kosong');
      }
      if (password.length < 6) {
        throw Exception('Password minimal 6 karakter');
      }

      _currentUser = await _authRepository.loginWithEmail(email, password);
      _errorMessage = null; // Clear error on success
    } catch (e) {
      _errorMessage = _formatErrorMessage(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Validate inputs
      if (!_isValidEmail(email)) {
        throw Exception('Format email tidak valid');
      }
      if (name.isEmpty) {
        throw Exception('Nama tidak boleh kosong');
      }
      if (password.isEmpty) {
        throw Exception('Password tidak boleh kosong');
      }
      if (password.length < 6) {
        throw Exception('Password minimal 6 karakter');
      }

      _currentUser = await _authRepository.signUpWithEmail(
        email,
        password,
        name,
      );
      _errorMessage = null; // Clear error on success
    } catch (e) {
      _errorMessage = _formatErrorMessage(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authRepository.loginWithGoogle();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.signOut();
      _currentUser = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.resetPassword(email);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  bool _isValidEmail(String email) {
    // Simple email validation regex
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  String _formatErrorMessage(String error) {
    // Format Firebase error messages into user-friendly Indonesian
    if (error.contains('user-not-found')) {
      return 'Email tidak terdaftar';
    } else if (error.contains('wrong-password')) {
      return 'Password salah';
    } else if (error.contains('email-already-in-use')) {
      return 'Email sudah terdaftar';
    } else if (error.contains('weak-password')) {
      return 'Password terlalu lemah';
    } else if (error.contains('invalid-email')) {
      return 'Format email tidak valid';
    } else if (error.contains('network')) {
      return 'Masalah koneksi internet';
    } else if (error.contains('PERMISSION_DENIED')) {
      return 'Akses ditolak. Pastikan Firestore security rules sudah configured.';
    } else if (error.contains('Exception:')) {
      return error.replaceAll('Exception: ', '');
    }
    return error;
  }
}
