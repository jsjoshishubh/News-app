import 'package:flutter/material.dart';

const MaterialColor primaryColor = MaterialColor(
  _bluePrimaryValue,
  <int, Color>{
    50: Color(0xFF487EE7),
    100: Color(0xFF487EE7),
    200: Color(0xFF487EE7),
    300: Color(0xFF487EE7),
    400: Color(0xFF487EE7),
    500: Color(0xFF487EE7),
    600: Color(0xFF487EE7),
    700: Color(0xFF487EE7),
    800: Color(0xFF487EE7),
    900: Color(0xFF487EE7),
  },
);
const MaterialColor secondryAppColor = MaterialColor(
  _greenPrimaryValue,
  <int, Color>{
    50: Color(0xFF9EC750),
    100: Color(0xFF9EC750),
    200: Color(0xFF9EC750),
    300: Color(0xFF9EC750),
    400: Color(0xFF9EC750),
    500: Color(0xFF9EC750),
    600: Color(0xFF9EC750),
    700: Color(0xFF9EC750),
    800: Color(0xFF9EC750),
    900: Color(0xFF9EC750),
  },
);

const MaterialColor fontColor = MaterialColor(
  _fornColor,
  <int, Color>{
    50: Color(0xFF2c3e50),
    100: Color(0xFF2c3e50),
    200: Color(0xFF2c3e50),
    300: Color(0xFF2c3e50),
    400: Color(0xFF2c3e50),
    500: Color(0xFF2c3e50),
    600: Color(0xFF2c3e50),
    700: Color(0xFF2c3e50),
    800: Color(0xFF2c3e50),
    900: Color(0xFF2c3e50),
  },
);

const MaterialColor appBarColor = MaterialColor(
  _appBarColor,
  <int, Color>{
    50: Color(0xFF2c3e50),
    100: Color(0xFF2c3e50),
    200: Color(0xFF2c3e50),
    300: Color(0xFF2c3e50),
    400: Color(0xFF2c3e50),
    500: Color(0xFF2c3e50),
    600: Color(0xFF2c3e50),
    700: Color(0xFF2c3e50),
    800: Color(0xFF2c3e50),
    900: Color(0xFF2c3e50),
  },
);

const int _bluePrimaryValue = 0xFF2c3e50;
const int _greenPrimaryValue = 0xFFa4cc38;
const int _fornColor = 0xFF2c3e50;
const int _appBarColor = 0xFF444444;


extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}