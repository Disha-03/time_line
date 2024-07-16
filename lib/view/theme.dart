import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ThemeData lightTheme = ThemeData.light().copyWith(
  primaryColor: Colors.blue,
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.blueGrey,
);

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  late SharedPreferences _prefs;
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  ThemeNotifier() {
    _loadFromPrefs();
  }

  toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _isDarkTheme = _prefs.getBool(key) ?? false;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _prefs.setBool(key, _isDarkTheme);
  }
}
