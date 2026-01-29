import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<bool> signUp(String username, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Check if user already exists
      final existingUser = await StorageService.getUserByEmail(email);
      if (existingUser != null) {
        _isLoading = false;
        notifyListeners();
        return false; // User already exists
      }

      // Create new user
      final userId = DateTime.now().millisecondsSinceEpoch.toString();
      final user = User(
        id: userId,
        username: username,
        email: email,
      );

      await StorageService.saveUser(user);

      // Save login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', userId);

      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await StorageService.getUserByEmail(email);
      if (user == null) {
        _isLoading = false;
        notifyListeners();
        return false; // User not found
      }

      // In a real app, verify password here
      // For simplicity, we'll just check if user exists

      // Save login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', user.id);

      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      _currentUser = await StorageService.getUser(userId);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userId');
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateProfile(String username, String email) async {
    if (_currentUser == null) return;

    final updatedUser = User(
      id: _currentUser!.id,
      username: username,
      email: email,
      profileImage: _currentUser!.profileImage,
    );

    await StorageService.saveUser(updatedUser);
    _currentUser = updatedUser;
    notifyListeners();
  }
}
