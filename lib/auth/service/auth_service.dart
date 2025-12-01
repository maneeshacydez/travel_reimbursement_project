import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_reimbursement/dashboard/model/user_model.dart';

class AuthService {
  static const String usersKey = "users";
  static const String currentUserKey = "current_user";

  // Initialize default users (run once)
  static Future<void> initializeUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? raw = prefs.getString(usersKey);

    if (raw == null) {
      // Create default users
      List<User> defaultUsers = [
        User(username: "rep", password: "rep123", role: "rep"),
        User(username: "finance", password: "finance123", role: "finance"),
      ];

      prefs.setString(
        usersKey,
        jsonEncode(defaultUsers.map((e) => e.toMap()).toList()),
      );
    }
  }

  // Login
  static Future<User?> login(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? raw = prefs.getString(usersKey);

    if (raw == null) return null;

    List decoded = jsonDecode(raw);
    List<User> users = decoded.map((e) => User.fromMap(e)).toList();

    for (var user in users) {
      if (user.username == username && user.password == password) {
        // Save current user
        prefs.setString(currentUserKey, jsonEncode(user.toMap()));
        return user;
      }
    }

    return null;
  }

  // Get current logged-in user
  static Future<User?> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? raw = prefs.getString(currentUserKey);

    if (raw == null) return null;

    return User.fromMap(jsonDecode(raw));
  }

  // Logout
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(currentUserKey);
  }
}