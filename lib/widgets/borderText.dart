import 'package:flutter/material.dart';

class BorderText extends StatelessWidget {
  const BorderText(
      {Key key,
      @required this.text,
      this.borderColor,
      this.textColor,
      this.strokeWidth,
      this.fontSize})
      : super(key: key);

  final String text;
  final Color borderColor;
  final Color textColor;
  final double strokeWidth;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          // Stroked text as border.
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? 20,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = strokeWidth ?? 2
                ..color = borderColor ?? Colors.grey[300],
            ),
            textAlign: TextAlign.center,
          ),
          // Solid text as fill.
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize ?? 20,
              color: textColor ?? Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
