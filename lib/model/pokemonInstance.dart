import 'dart:convert';

import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/model/team.dart';

import 'ability.dart';
import 'nature.dart';

class PokemonInstance extends Pokemon {
  String firstName;
  Team team;

  Ability abilitySelected;

  Map<BaseStatName, int> IV;
  Map<BaseStatName, int> EV;

  Nature nature;

  ///creazione a partire da un pokemon e un team
  ///inserisce come [abilitySelected] la prima del pokemon
  PokemonInstance(Pokemon pokemon, Team team, String firstName)
      : super(
            name: pokemon.name,
            id: pokemon.id,
            type1: pokemon.type1,
            type2: pokemon.type2) {
    this.firstName = firstName;
    super.baseStats = pokemon.baseStats;
    super.abilities = pokemon.abilities;
    super.urlSprite = pokemon.urlSprite;
    this.team = team;
    abilitySelected = pokemon.abilities.first;
    nature = Nature(NatureName.Hardy);
  }

  PokemonInstance.fromMap(int dbKey, Map<String, dynamic> pokemonMap, Team team)
      : super.fromMap(dbKey, pokemonMap) {
    this.team = team;
    this.firstName = pokemonMap['firstName'];
    this.abilitySelected = new Ability.fromMap(jsonDecode(pokemonMap['abilitySelected']));
    this.nature = Nature(NatureName.values[pokemonMap['nature']]);
  }

  Map<String, dynamic> get map {
    Map<String, dynamic> returnMap = super.map;
    returnMap.addAll({
      'firstName': this.firstName,
      'teamDbKey': team.dbKey,
      'abilitySelected': jsonEncode(abilitySelected),
      'nature': nature.name.index,
    });
    return returnMap;
  }
}
