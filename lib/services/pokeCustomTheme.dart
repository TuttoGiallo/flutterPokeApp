import 'dart:ui';
import 'package:flutter/material.dart';

class PokeCustomTheme {
  static TextStyle getValueStyle() {
    return TextStyle(
      fontSize: 28.0,
      color: Colors.grey[500],
      fontStyle: FontStyle.italic,
    );
  }

  static TextStyle getFieldStyle() {
    return TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: Colors.amber,
    );
  }
}
