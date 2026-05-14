import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
	// ── private fields ──
	String _userName = '';
	String _userEmail = '';
	String _userCourse = '';

	// ── public getters — screens read these ──
	String get userName => _userName;
	String get userEmail => _userEmail;
	String get userCourse => _userCourse;

	// ── true if user has set their name ──
	bool get hasUser => _userName.isNotEmpty;

	// ── called once in main.dart before app renders ──
	Future<void> loadFromPrefs() async {
		final prefs = await SharedPreferences.getInstance();
		_userName = prefs.getString('userName') ?? '';
		_userEmail = prefs.getString('userEmail') ?? '';
		_userCourse = prefs.getString('userCourse') ?? '';
		notifyListeners();
	}

	// ── saves all profile fields at once ──
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

		notifyListeners();
	}

	// ── clears everything — called on log out ──
	Future<void> logout() async {
		_userName = '';
		_userEmail = '';
		_userCourse = '';

		final prefs = await SharedPreferences.getInstance();
		await prefs.remove('userName');
		await prefs.remove('userEmail');
		await prefs.remove('userCourse');

		notifyListeners();
	}
}
