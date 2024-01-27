import 'package:flutter/material.dart';

class GlobalTheme {
  GlobalTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
  );
}
