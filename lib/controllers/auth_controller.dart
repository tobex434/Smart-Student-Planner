import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/database_helper.dart';
import '../models/user.dart';
import 'task_controller.dart';

class AuthController extends ChangeNotifier {
  // ── private fields ──
  String _userName = '';
  String _userEmail = '';
  String _userCourse = '';
  int? _userId;
  bool _isLoggedIn = false;
  TaskController? _taskController;

  // ── public getters ──
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userCourse => _userCourse;
  int? get userId => _userId;
  bool get isLoggedIn => _isLoggedIn;

  void setTaskController(TaskController taskController) {
    _taskController = taskController;
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _userName = prefs.getString('userName') ?? '';
    _userEmail = prefs.getString('userEmail') ?? '';
    _userCourse = prefs.getString('userCourse') ?? '';
    _userId = prefs.getInt('userId');

    if (_isLoggedIn && _userId != null) {
      await _taskController?.loadTasksForUser(_userId!);
    }

    notifyListeners();
  }

  // ── checks if any account exists in SQLite ──
  Future<bool> hasExistingAccount() async {
    return await DatabaseHelper.instance.hasAnyUser();
  }

  //
  // SIGN UP
  //

  // ── returns null on success, error message string on failure ──
  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
    String course = '',
  }) async {
    // basic validation
    if (name.trim().isEmpty) return 'Please enter your name';
    if (email.trim().isEmpty) return 'Please enter your email';
    if (password.trim().isEmpty) return 'Please enter a password';
    if (password.length < 6) return 'Password must be at least 6 characters';

    // check if email already exists
    final existing = await DatabaseHelper.instance.getUserByEmail(email.trim());
    if (existing != null) return 'An account with this email already exists';

    // create and insert user
    final user = User(
      name: name.trim(),
      email: email.trim().toLowerCase(),
      password: password,
      course: course.trim(),
    );

    final id = await DatabaseHelper.instance.insertUser(user);

    // save session
    await _saveSession(
      id: id,
      name: name.trim(),
      email: email.trim().toLowerCase(),
      course: course.trim(),
    );

    return null;
  }

  //
  // LOGIN
  //

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty) return 'Please enter your email';
    if (password.trim().isEmpty) return 'Please enter your password';

    // find user by email
    final user = await DatabaseHelper.instance.getUserByEmail(
      email.trim().toLowerCase(),
    );

    if (user == null) return 'No account found with this email';

    // check password
    if (user.password != password) return 'Incorrect password';

    // save session
    await _saveSession(
      id: user.id!,
      name: user.name,
      email: user.email,
      course: user.course,
    );

    return null;
  }

  //
  // PROFILE
  //

  Future<void> saveProfile({
    required String name,
    required String email,
    required String course,
  }) async {
    _userName = name;
    _userEmail = email;
    _userCourse = course;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    await prefs.setString('userCourse', course);

    // update SQLite too
    if (_userId != null) {
      final user = User(
        id: _userId,
        name: name,
        email: email,
        password: '',
        course: course,
      );
      await DatabaseHelper.instance.updateUser(user);
    }

    notifyListeners();
  }

  //
  // LOGOUT
  //

  Future<void> logout() async {
    _taskController?.clearTasks();

    _userName = '';
    _userEmail = '';
    _userCourse = '';
    _userId = null;
    _isLoggedIn = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userCourse');
    await prefs.remove('userId');
    await prefs.setBool('isLoggedIn', false);

    notifyListeners();
  }

  //
  // PRIVATE
  //

  Future<void> _saveSession({
    required int id,
    required String name,
    required String email,
    required String course,
  }) async {
    _userId = id;
    _userName = name;
    _userEmail = email;
    _userCourse = course;
    _isLoggedIn = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', id);
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    await prefs.setString('userCourse', course);
    await prefs.setBool('isLoggedIn', true);

    await _taskController?.loadTasksForUser(id);

    notifyListeners();
  }
}
