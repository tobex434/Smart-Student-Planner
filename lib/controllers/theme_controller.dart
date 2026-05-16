import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
	// ── private state ──
	ThemeMode _themeMode = ThemeMode.system;
	Color _seedColour = const Color(0xFF1565C0);
	bool _useDynamicColour = true;

	// ── public getters ──
	ThemeMode get themeMode => _themeMode;
	Color get seedColour => _seedColour;
	bool get useDynamicColour => _useDynamicColour;

	// ── called once in main.dart before app renders ──
	Future<void> loadFromPrefs() async {
		final prefs = await SharedPreferences.getInstance();

		// ThemeMode stored as int — 0=system, 1=light, 2=dark
		final modeIndex = prefs.getInt('themeMode') ?? 0;
		_themeMode = ThemeMode.values[modeIndex];

		// seed colour stored as int (Color.value)
		final colourValue = prefs.getInt('seedColour') ?? 0xFF1565C0;
		_seedColour = Color(colourValue);

		_useDynamicColour = prefs.getBool('useDynamicColour') ?? true;

		notifyListeners();
	}

	// ── called from Settings dark mode toggle ──
	Future<void> setThemeMode(ThemeMode mode) async {
		_themeMode = mode;
		final prefs = await SharedPreferences.getInstance();
		await prefs.setInt('themeMode', mode.index);
		notifyListeners();
	}

	// ── called from Settings app theme dropdown ──
	Future<void> setThemeModeFromString(String value) async {
		switch (value) {
			case 'Light':
				await setThemeMode(ThemeMode.light);
				break;
			case 'Dark':
				await setThemeMode(ThemeMode.dark);
				break;
			case 'System':
			default:
				await setThemeMode(ThemeMode.system);
				break;
		}
	}

	// ── returns the current theme as a display string ──
	String get themeModeLabel {
		switch (_themeMode) {
			case ThemeMode.light:
				return 'Light';
			case ThemeMode.dark:
				return 'Dark';
			case ThemeMode.system:
			default:
				return 'System';
		}
	}

	// ── called if you add a colour picker later ──
	Future<void> setSeedColour(Color colour) async {
		_seedColour = colour;
		final prefs = await SharedPreferences.getInstance();
		await prefs.setInt('seedColour', colour.value);
		notifyListeners();
	}

	// ── called from dynamic colour toggle in Settings ──
	Future<void> setUseDynamicColour(bool value) async {
		_useDynamicColour = value;
		final prefs = await SharedPreferences.getInstance();
		await prefs.setBool('useDynamicColour', value);
		notifyListeners();
	}
}
