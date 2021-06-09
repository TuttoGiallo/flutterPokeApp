import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemonType.dart';
import 'package:poke_team/services/typeColors.dart';

class PokeTypeContainer extends StatelessWidget {
  const PokeTypeContainer(this.type,
      {Key key, this.alternativeStringPrint, this.fixWidth = -1})
      : super(key: key);
  final PokemonType type;
  final String alternativeStringPrint;
  final double fixWidth;


  Container containerWithWidth(Widget child) {

    BoxDecoration boxDecoration = BoxDecoration(
      color: TypeColors.getTypeColor(type.name),
      border: Border.all(
        color: Colors.black,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(8),
    );

    Container containerWithWidth;
    fixWidth == -1 ? containerWithWidth =
        Container(
      decoration: boxDecoration,
      child: child,
    ) : containerWithWidth = Container(
      width: fixWidth,
      decoration: boxDecoration,
      child: child,
    );
    return containerWithWidth;
  }

  @override
  Widget build(BuildContext context) {
    if (type == null) return Container();
    return containerWithWidth(
      Center( //TODO sostituire con borederText
        child: Stack(
          children: <Widget>[
            // Stroked text as border.
            Text(
              alternativeStringPrint ?? type.name,
              style: TextStyle(
                fontSize: 20,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2
                  ..color = Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            // Solid text as fill.
            Text(
              alternativeStringPrint ?? type.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
