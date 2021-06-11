import 'dart:convert';

import 'package:poke_team/model/ability.dart';
import 'package:poke_team/model/pokemonStats.dart';
import 'package:poke_team/model/pokemonType.dart';
import 'package:poke_team/model/pokemonTypes.dart';

class Pokemon {
  String name;
  int id;

  //usata per identificare più pokemon dello stesso tipo nello stesso team, valorizzata da DB - 0 valore di default
  int dbKey = -1; //TODO spostare su instance

  bool isStored() => this.dbKey != -1;

  PokemonType type1;
  PokemonType type2;

  String urlSprite;

  List<Ability> abilities;

  //Base Stats:
  Map<StatName, int> baseStats = PokemonStats.getNewInitializedMapBaseStats();

  set baseHp(int hp) => baseStats[StatName.hp] = hp;

  set baseAttack(int attack) => baseStats[StatName.attack] = attack;

  set baseDefense(int defense) => baseStats[StatName.defense] = defense;

  set baseSpecialAttack(int specialAttack) =>
      baseStats[StatName.specialAttack] = specialAttack;

  set baseSpecialDefense(int specialDefence) =>
      baseStats[StatName.specialDefense] = specialDefence;

  set baseSpeed(int speed) => baseStats[StatName.speed] = speed;

  get baseHp => baseStats[StatName.hp];

  get baseAttack => baseStats[StatName.attack];

  get baseDefense => baseStats[StatName.defense];

  get baseSpecialAttack => baseStats[StatName.specialAttack];

  get baseSpecialDefense => baseStats[StatName.specialDefense];

  get baseSpeed => baseStats[StatName.speed];

  Pokemon({this.name, this.id, this.type1, this.type2}) {
    this.abilities = [];
  }

  Pokemon.fromStringType(this.name, {this.id, String type1, String type2}) {
    this.type1 = PokemonTypes().getTypeFromName(type1 ?? '');
    this.type2 = PokemonTypes().getTypeFromName(type2 ?? '');
  }

  Pokemon.fromMap(this.dbKey, Map<String, dynamic> pokemonMap) {
    id = pokemonMap['id'];
    name = pokemonMap['name'];
    type1 = PokemonTypes().getTypeFromName(pokemonMap['type1']);
    type2 = PokemonTypes().getTypeFromName(pokemonMap['type2']);
    urlSprite = pokemonMap['urlSprite'];
    List<dynamic> abilitiesData = json.decode(pokemonMap['abilities']);
    abilities = [];
    abilitiesData.forEach((abilityMap) {
      abilities.add(new Ability.fromMap(abilityMap));
    });
    baseHp = pokemonMap['baseHp'];
    baseAttack = pokemonMap['baseAttack'];
    baseDefense = pokemonMap['baseDefense'];
    baseSpecialAttack = pokemonMap['baseSpecialAttack'];
    baseSpecialDefense = pokemonMap['baseSpecialDefense'];
    baseSpeed = pokemonMap['baseSpeed'];
  }

  Map<String, dynamic> get map {
    return {
      'id': id,
      'name': name,
      'type1': type1.name,
      'type2': type2 != null ? type2.name : '',
      'urlSprite': urlSprite,
      'abilities': jsonEncode(abilities),
      'baseHp': baseHp,
      'baseAttack': baseAttack,
      'baseDefense': baseDefense,
      'baseSpecialAttack': baseSpecialAttack,
      'baseSpecialDefense': baseSpecialDefense,
      'baseSpeed': baseSpeed,
    };
  }
}

