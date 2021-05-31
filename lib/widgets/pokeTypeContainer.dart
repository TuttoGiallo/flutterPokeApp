import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemonType.dart';
import 'package:poke_team/services/typeColors.dart';

class PokeTypeContainer extends StatelessWidget {
  const PokeTypeContainer(this.type, {Key key}) : super(key: key);
  final PokemonType type;

  @override
  Widget build(BuildContext context) {
    if (type == null) return Container();
    return Container(
      decoration: BoxDecoration(
        color: TypeColors.getTypeColor(type.name),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Center(
        child: Stack(
          children: <Widget>[
            // Stroked text as border.
            Text(
              type.name,
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
              type.name,
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
