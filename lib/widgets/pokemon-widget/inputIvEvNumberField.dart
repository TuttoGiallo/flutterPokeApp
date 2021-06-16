import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poke_team/model/pokemonStats.dart';

class InputIvEvNumberField extends StatelessWidget {
  InputIvEvNumberField(
      {Key key,
      this.width = 80,
      @required this.text,
      this.labelText = '',
      this.labelStyle,
      this.maxLength = 3,
      @required this.onChanged,
      @required this.ivOrEv,
      @required this.statName})
      : super(key: key);

  final Function(String changeValue, StatName statName, IVEV ivOrEv) onChanged;
  final TextEditingController numberController = TextEditingController();
  final text;
  final IVEV ivOrEv;
  final double width;
  final String labelText;
  final TextStyle labelStyle;
  final int maxLength;
  final StatName statName;

  @override
  Widget build(BuildContext context) {
    numberController.text = text;
    numberController.selection = TextSelection.fromPosition(TextPosition(offset: numberController.text.length));
    return Container(
        alignment: Alignment.bottomRight,
        width: width,
        child: TextField(
          onChanged: (textChanged) => textChanged.isNotEmpty
              ? onChanged(textChanged, statName, ivOrEv)
              : null,
          maxLength: maxLength,
          controller: numberController,
          autocorrect: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            isDense: true,
            labelText: labelText,
            labelStyle: labelStyle,
            counterText: "",
          ),
        ));
  }
}

enum IVEV { EV, IV }
