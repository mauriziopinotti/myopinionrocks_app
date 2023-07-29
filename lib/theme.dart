import 'package:flutter/material.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
  textTheme: textTheme,
  useMaterial3: false,
);

const primaryColor = Color(0xFFe93236);
const textColor = Color(0xFF515b63);
const appBarColor = Colors.white;

MaterialStateProperty<Color> get primaryColorMaterial =>
    MaterialStateProperty.all<Color>(primaryColor);

const textTheme = TextTheme(
  // Es. nome nel profilo (3.6rem)
  displayLarge /* headline1 */ : TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    fontSize: 28,
    color: Colors.black,
  ),
  // Icone bottom bar (3rem)
  displayMedium /* headline2 */ : TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    fontSize: 42,
    color: Colors.white,
  ),
  // Es. i pulsanti "Ferie", "Malattia", etc. (2.5rem)
  displaySmall /* headline3 */ : TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    fontSize: 26,
    color: Colors.white,
  ),
  // Nomi dei task e pulsanti (2rem)
  titleMedium /* subtitle1 */ : TextStyle(
    fontFamily: 'Roboto',
    fontSize: 22,
    color: Colors.black,
  ),
  // Pulsanti (2rem)
  labelLarge /* button */ : TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    fontSize: 22,
    color: Colors.white,
  ),
  // Scritte tipo la data (1.4rem)
  bodyLarge /* bodyText1 */ : TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    fontSize: 20,
    color: Color(0xFF888888),
  ),
  // Scritte in piccolo nelle liste
  bodyMedium /* bodyText2 */ : TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w300,
    fontSize: 16,
    color: Color(0xFF888888),
  ),
);

const snackBarStyle = TextStyle(
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w300,
  fontSize: 16,
  color: Color(0xFFFFFFFF),
);
