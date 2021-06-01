import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemon.dart';

class PokeElement extends StatefulWidget {
  const PokeElement({Key key, @required this.poke, @required this.deletePokemonFunctionCallBack}) : super(key: key);

  final Pokemon poke;
  final Function(Pokemon poke) deletePokemonFunctionCallBack;
  @override
  _PokeElementState createState() => _PokeElementState();
}

class _PokeElementState extends State<PokeElement> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.poke.name);
  }
}
