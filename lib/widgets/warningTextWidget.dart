import 'package:flutter/material.dart';

class WarningTextWidget extends StatelessWidget {
  const WarningTextWidget({Key key, this.text = '', this.width = 250})
      : super(key: key);

  final String text;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.fromLTRB(0, 5, 0, 5),
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.redAccent),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.warning, color: Colors.yellowAccent),
          Container(
              width: width * 4 / 7,
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.yellowAccent, fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
