import 'package:flutter/material.dart';
import 'package:poke_team/pages/loading.dart';
import 'package:poke_team/pages/pokeApp.dart';
import 'package:poke_team/pages/pokemonPage.dart';
import 'package:poke_team/pages/teamPage.dart';
import 'package:poke_team/pages/teamsPage.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/teams': (context) => TeamsPage(),
      '/team': (context) => TeamPage(),
      '/loading': (context) => Loading(),
      '/poke': (context) => PokemonPage(),
      '/': (context) => PokeApp(),
    },

  ));
}
