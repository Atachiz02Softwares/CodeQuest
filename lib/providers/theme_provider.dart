import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme() async {
    _darkTheme = !_darkTheme;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkTheme', _darkTheme);
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _darkTheme = prefs.getBool('darkTheme') ?? false;
    notifyListeners();
  }
}

final themeNotifierProvider = ChangeNotifierProvider((_) => ThemeProvider());
