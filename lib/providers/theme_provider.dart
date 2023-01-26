import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // depends on system themeMode
  ThemeMode themeMode = ThemeMode.system;
  //custom themeMode
  //ThemeMode themeMode = ThemeMode.dark;
  bool get isDarkMode => themeMode == ThemeMode.dark;
  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(color: Colors.black),
    scaffoldBackgroundColor: Colors.grey.shade900,
    cardColor: Colors.white,
    primaryColor: Colors.black12,
    colorScheme: const ColorScheme.dark(),
    iconTheme: const IconThemeData(color: Colors.white, opacity: 0.8),
  );
  static final lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(color: Colors.blueGrey),
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.black,
    primaryColor: Colors.grey.shade100,
    colorScheme: const ColorScheme.light(),
    iconTheme: const IconThemeData(color: Colors.black, opacity: 0.8),
  );
}
