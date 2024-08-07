import 'package:flutter/material.dart';

// Background colors.
const _backgroundPrimary = Color(0xFFFFFFFF);
const _backgroundSecondary = Color(0xFFF2F2F2);
const _backgroundOnScroll = Color(0xFFF2F5FC);

// Elements colors.
const _primaryColor = Colors.green;
const _dividerColor = Color(0xFFE1E1E1);

// Error colors.
const _errorRed = Color(0xFFFF3B30);

// Text colors.
const _tertiaryColor = Color(0xFFDCDCDC);
const _quaternaryColor = Color.fromARGB(255, 112, 112, 112);

extension AppColorScheme on ColorScheme {
  // Background colors.
  Color get backgroundPrimary => _backgroundPrimary;
  Color get backgroundSecondary => _backgroundSecondary;
  Color get backgroundOnScroll => _backgroundOnScroll;

  Color get dividerColor => _dividerColor;

  // Text color.
  Color get tertiaryColor => _tertiaryColor;
  Color get quaternaryColor => _quaternaryColor;
}

final wbTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: _primaryColor,
  secondaryHeaderColor: _primaryColor,
  scaffoldBackgroundColor: _backgroundPrimary,
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(borderSide: BorderSide(color: _dividerColor, width: 1.0)),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: _dividerColor, width: 1.0)),
  ),
  colorScheme: const ColorScheme.light(
    error: _errorRed,
    errorContainer: _errorRed,
    onErrorContainer: _errorRed,
    onError: _errorRed,
    primary: _primaryColor,
    onPrimary: _primaryColor,
    primaryContainer: _primaryColor,
    onPrimaryContainer: _primaryColor,
    tertiary: _tertiaryColor,
  ),
  primarySwatch: Colors.green,
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.black),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: _primaryColor),
  unselectedWidgetColor: Colors.black45,
  primaryColorLight: _primaryColor,
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: _primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    ),
  ),
  buttonTheme: ButtonThemeData(
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple).copyWith(
      secondary: _primaryColor,
      primary: _primaryColor,
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      disabledBackgroundColor: _dividerColor,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: _primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
    iconColor: WidgetStateProperty.all(_quaternaryColor),
  )),
  tabBarTheme: TabBarTheme(
    labelStyle: const TextStyle(color: Colors.white),
    labelColor: Colors.white,
    dividerColor: Colors.white,
    indicatorColor: Colors.white,
    unselectedLabelColor: Colors.white.withAlpha(180),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Colors.white,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.black,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    contentTextStyle: const TextStyle(color: Colors.white),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    surfaceTintColor: Colors.transparent, // remove tint color
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: Colors.black,
    smallSizeConstraints: BoxConstraints.tight(const Size.square(44)),
  ),
  dividerTheme: const DividerThemeData(
    color: _dividerColor,
    space: 1,
  ),
);
