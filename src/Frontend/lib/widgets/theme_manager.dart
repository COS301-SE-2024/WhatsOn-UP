import 'package:flutter/material.dart';
import 'storage_manager.dart';

// Light colours
const Color lightPrimaryColor = Color.fromARGB(255, 48, 86, 139);
const Color lightSecondaryColor = Color.fromARGB(255, 149, 137, 74);
const Color lightBackgroundColor = Colors.white;
const Color lightTextColor = Colors.black;

// Dark colours
const Color darkPrimaryColor = Color.fromARGB(255, 13, 71, 161);
const Color darkSecondaryColor = Color.fromARGB(255, 149, 137, 74);
// const Color darkBackgroundColor = Color.fromARGB(255, 31, 31, 31);
const Color darkBackgroundColor = Color.fromARGB(255, 18, 18, 18);

class ThemeNotifier with ChangeNotifier {
  final lightTheme = ThemeData(
    primaryColor: lightPrimaryColor,
    colorScheme: const ColorScheme.light(
      primary: lightPrimaryColor,
      secondary: lightSecondaryColor,
      surface: lightBackgroundColor,
    ),
    textTheme: const TextTheme(
        // bodyText1: TextStyle(color: lightTextColor),
        // bodyText2: TextStyle(color: lightTextColor),
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lightPrimaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      // backgroundColor: lightPrimaryColor,
      // selectedItemColor: lightSecondaryColor,
      // unselectedItemColor: Colors.white,
      backgroundColor: Colors.white,
      selectedItemColor: lightSecondaryColor,
      unselectedItemColor: Color.fromARGB(255, 47, 86, 194),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // foregroundColor: Colors.black,
        foregroundColor: Colors.white,
        // backgroundColor: Colors.white,
        backgroundColor: lightPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          // side: const BorderSide(color: Colors.grey, width: 1),
          // side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255), width: 1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color.fromARGB(255, 13, 71, 161),
      ),
    ),
  );

  final darkTheme = ThemeData(
    primaryColor: darkPrimaryColor,
    colorScheme: const ColorScheme.dark(
      primary: darkPrimaryColor,
      secondary: darkSecondaryColor,
      surface: darkBackgroundColor,
    ),
    textTheme: const TextTheme(
        // bodyText1: TextStyle(color: darkTextColor),
        // bodyText2: TextStyle(color: darkTextColor),
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkPrimaryColor,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      // backgroundColor: darkPrimaryColor,
      // selectedItemColor: darkSecondaryColor,
      // unselectedItemColor: Colors.white,
      backgroundColor: Color.fromARGB(255, 18, 18, 18),
      selectedItemColor: darkSecondaryColor,
      unselectedItemColor: Color.fromARGB(255, 79, 114, 207),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        // backgroundColor: Color.fromARGB(255, 18, 18, 18),
        backgroundColor: darkPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          // side: BorderSide(color: const Color.fromARGB(255, 255, 255, 255), width: 1),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Color.fromARGB(255, 60, 128, 230),
      ),
    ),
  );

  late ThemeData _themeData;
  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    _themeData = lightTheme;
    StorageManager.readData('themeMode').then((value) {
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}
