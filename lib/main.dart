import 'package:flutter/material.dart';
import 'package:poke_team/pages/home.dart';
import 'package:poke_team/pages/loading.dart';
import 'package:poke_team/pages/poke.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/loading': (context) => Loading(),
      '/poke': (context) => Poke(),
    },

  ));
}
