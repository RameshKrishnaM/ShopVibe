import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appcart/core/utils/validators.dart';
import 'package:appcart/data/models/user_model.dart';

/// Repository interface handling local authentication and session persistence
class AuthRepository {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  /// Loads saved user session from local storage
  Future<UserModel?> getSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('saved_user_email');
      if (email != null && email.isNotEmpty) {
        final id = prefs.getString('saved_user_id') ?? 'usr_saved';
        final displayName = prefs.getString('saved_user_name') ??
            email.split('@').first.replaceFirstMapped(
                  RegExp(r'^[a-z]'),
                  (m) => m[0]!.toUpperCase(),
                );
        final avatarUrl = prefs.getString('saved_user_avatar') ??
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80';

        _currentUser = UserModel(
          id: id,
          email: email,
          displayName: displayName,
          avatarUrl: avatarUrl,
        );
        return _currentUser;
      }
    } catch (_) {
      // In test or initial environments, SharedPreferences might be uninitialized
    }
    return null;
  }

  /// Authenticates user against local/dummy credentials and persists session locally
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate real-world network latency
    await Future.delayed(const Duration(milliseconds: 600));

    final trimmedEmail = email.trim();
    if (!Validators.isEmailValid(trimmedEmail)) {
      throw Exception('Invalid email format');
    }

    if (!Validators.isPasswordValid(password)) {
      throw Exception('Password must be at least 6 characters');
    }

    // Success authentication payload
    final user = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      email: trimmedEmail,
      displayName: trimmedEmail.split('@').first.replaceFirstMapped(
            RegExp(r'^[a-z]'),
            (m) => m[0]!.toUpperCase(),
          ),
      avatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
    );

    _currentUser = user;

    // Persist session to local storage
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_user_id', user.id);
      await prefs.setString('saved_user_email', user.email);
      await prefs.setString('saved_user_name', user.displayName);
      if (user.avatarUrl != null) {
        await prefs.setString('saved_user_avatar', user.avatarUrl!);
      }
    } catch (_) {
      // Continue even if local write fails in unit tests
    }

    return user;
  }

  /// Logs out the active user session and clears local storage
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('saved_user_id');
      await prefs.remove('saved_user_email');
      await prefs.remove('saved_user_name');
      await prefs.remove('saved_user_avatar');
    } catch (_) {
      // Continue even if storage clear fails in unit tests
    }
  }
}

