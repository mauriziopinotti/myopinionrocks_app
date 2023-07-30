import 'package:flutter/material.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
  textTheme: textTheme,
  useMaterial3: false,
);

const primaryColor = Color(0xFFe93236);
const secondaryColor = Color(0xFF4f96f6);
const tertiaryColor = Color(0xFFfbc234);
const textColor = Color(0xFF515b63);
const appBarColor = Colors.white;

MaterialStateProperty<Color> get primaryColorMaterial =>
    MaterialStateProperty.all<Color>(primaryColor);

const textTheme = TextTheme(
  // displayMedium: TextStyle(
  //   fontFamily: 'Roboto',
  //   fontWeight: FontWeight.normal,
  //   fontSize: 42,
  //   color: textColor,
  // ),
  // displaySmall: TextStyle(
  //   fontFamily: 'Roboto',
  //   fontWeight: FontWeight.normal,
  //   fontSize: 26,
  //   color: textColor,
  // ),
  titleMedium: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 22,
    color: textColor,
  ),
  labelLarge: TextStyle(
    fontFamily: 'Roboto',
    // fontWeight: FontWeight.normal,
    fontSize: 24,
    color: textColor,
  ),
  // bodyLarge: TextStyle(
  //   fontFamily: 'Roboto',
  //   fontWeight: FontWeight.normal,
  //   fontSize: 20,
  //   color: textColor,
  // ),
  bodyMedium: TextStyle(
    fontFamily: 'Roboto',
    // fontWeight: FontWeight.w300,
    fontSize: 18,
    color: textColor,
  ),
);
