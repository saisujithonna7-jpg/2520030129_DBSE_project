import 'package:flutter/foundation.dart';

import '../models/user.dart';

/// Phase 1 mock authentication service.
///
/// Keeps registered users in memory and persists only the *current*
/// session user so the splash screen can restore it while the app
/// process is alive. Swap this class for a real backend in Phase 2+.
class AuthService extends ChangeNotifier {
  AuthService._();
  static final AuthService instance = AuthService._();

  final Map<String, ({String password, AppUser user})> _accounts = {};
  AppUser? _currentUser;

  static const String _sessionKey = 'raktasetu_session_user';

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  /// Registers a new account. Returns an error message or null on success.
  String? register({
    required String fullName,
    required String email,
    required String phone,
    required String bloodGroup,
    required String area,
    required String password,
    int? age,
  }) {
    final key = email.trim().toLowerCase();
    if (_accounts.containsKey(key)) {
      return 'An account with this email already exists.';
    }
    final user = AppUser(
      id: 'u${_accounts.length + 1}',
      fullName: fullName.trim(),
      email: key,
      phone: phone.trim(),
      bloodGroup: bloodGroup,
      area: area,
      age: age,
    );
    _accounts[key] = (password: password, user: user);
    _currentUser = user;
    _persistSession(user);
    notifyListeners();
    return null;
  }

  /// Logs in with email + password. Returns an error message or null.
  String? login({required String email, required String password}) {
    final key = email.trim().toLowerCase();
    final account = _accounts[key];
    if (account == null) {
      // Phase 1 convenience: a demo account so the app is usable
      // without registering first.
      if (key == 'demo@raktasetu.in' && password == 'demo123') {
        _currentUser = _demoUser;
        _persistSession(_demoUser);
        notifyListeners();
        return null;
      }
      return 'No account found for this email. Please register.';
    }
    if (account.password != password) {
      return 'Incorrect password. Please try again.';
    }
    _currentUser = account.user;
    _persistSession(account.user);
    notifyListeners();
    return null;
  }

  /// Marks a reset link as "sent" (mock). Returns error message or null.
  String? sendPasswordReset(String email) {
    final key = email.trim().toLowerCase();
    if (key == 'demo@raktasetu.in') return null;
    if (!_accounts.containsKey(key)) {
      return 'No account found for this email.';
    }
    return null;
  }

  /// Updates the logged-in user's profile fields.
  void updateProfile({
    String? fullName,
    String? phone,
    String? bloodGroup,
    String? area,
    int? age,
  }) {
    final user = _currentUser;
    if (user == null) return;
    final updated = user.copyWith(
      fullName: fullName,
      phone: phone,
      bloodGroup: bloodGroup,
      area: area,
      age: age,
    );
    _currentUser = updated;
    // Keep the stored account in sync too.
    final account = _accounts[updated.email];
    if (account != null) {
      _accounts[updated.email] = (password: account.password, user: updated);
    }
    _persistSession(updated);
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _sessionBox.remove(_sessionKey);
    notifyListeners();
  }

  // ---- Tiny in-memory "storage" so the session survives within the
  // app process even if widgets are rebuilt from scratch (Phase 1 mock). ----
  static final Map<String, String> _sessionBox = {};

  void _persistSession(AppUser user) {
    // In Phase 2 this becomes secure storage / backend session.
    _sessionBox[_sessionKey] = user.email;
  }

  static const AppUser _demoUser = AppUser(
    id: 'u0',
    fullName: 'Demo Donor',
    email: 'demo@raktasetu.in',
    phone: '+91 90000 00000',
    bloodGroup: 'O+',
    area: 'Kukatpally',
    age: 28,
  );
}
