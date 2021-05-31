import 'package:flutter/material.dart';

class TypeColors{

  static final Map typeColorsMap =
  {
    'normal'  :   Color(0xB4E5D8D8),
    'grass'   :   Color(0xE83DDE10),
    'poison'  :   Colors.purple,
    'electric':   Colors.yellow,
    'water'   :   Colors.blueAccent,
    'fairy'   :   Colors.pink[200],
    'fire'    :   Colors.orange,
    'flying'  :   Color(0xA890F0FF),
    'rock'    :   Colors.brown[600],
    'ground'  :   Color(0xFFA87751),
    'bug'     :   Colors.lightGreen,
    'dragon'  :   Colors.deepPurple,
    'psychic' :   Colors.pink,
    'dark'    :   Colors.grey[850],
    'ghost'   :   Color(0x906043E0),
    'fighting':   Color(0xFFA53018),
    'ice'     :   Colors.cyanAccent,
    'steel'   :   Color(0xB8B8D0FF),
  };

  static Color getTypeColor(String type){
    return typeColorsMap[type] ?? Colors.white;
  }

}