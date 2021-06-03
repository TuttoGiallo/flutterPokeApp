import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteBackground extends StatelessWidget {
  const DeleteBackground({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconDeleteForBackGround(),
            TextDeleteForBackGround(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextDeleteForBackGround(),
            IconDeleteForBackGround(),
          ],
        ),
      ],
    );
  }
}

class TextDeleteForBackGround extends StatelessWidget {
  const TextDeleteForBackGround({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'DELETE',
      style: TextStyle(
        fontSize: 24,
        color: Colors.redAccent,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class IconDeleteForBackGround extends StatelessWidget {
  const IconDeleteForBackGround({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.delete,
      color: Colors.redAccent,
      size: 40,
    );
  }
}
