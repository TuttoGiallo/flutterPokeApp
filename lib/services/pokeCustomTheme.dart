import 'dart:ui';
import 'package:flutter/material.dart';

class PokeCustomTheme {
  static TextStyle getValueStyle({double fontSize = 24.0}) {
    return TextStyle(
      fontSize: fontSize,
      color: Colors.grey[500],
      fontStyle: FontStyle.italic,
    );
  }

  static TextStyle getFieldStyle({double fontSize = 20.0}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: Colors.amber,
    );
  }
}
