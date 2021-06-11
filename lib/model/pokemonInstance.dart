import 'dart:convert';

import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/model/pokemonStats.dart';
import 'package:poke_team/model/team.dart';

import 'ability.dart';
import 'nature.dart';

class PokemonInstance extends Pokemon {
  String firstName;
  Team team;

  Ability abilitySelected;

  Map<StatName, int> iV;
  Map<StatName, int> eV;

  int level;

  Nature nature;

  get hp => calcStat(StatName.hp);

  get attack => calcStat(StatName.attack);

  get defense => calcStat(StatName.defense);

  get specialAttack => calcStat(StatName.specialAttack);

  get specialDefense => calcStat(StatName.specialDefense);

  get speed => calcStat(StatName.speed);

  //IV
  set ivHp(int hp) => iV[StatName.hp] = hp;

  set ivAttack(int attack) => iV[StatName.attack] = attack;

  set ivDefense(int defense) => iV[StatName.defense] = defense;

  set ivSpecialAttack(int specialAttack) =>
      iV[StatName.specialAttack] = specialAttack;

  set ivSpecialDefence(int specialDefense) =>
      iV[StatName.specialDefense] = specialDefense;

  set ivSpeed(int speed) => iV[StatName.speed] = speed;

  get ivHp => iV[StatName.hp];

  get ivAttack => iV[StatName.attack];

  get ivDefense => iV[StatName.defense];

  get ivSpecialAttack => iV[StatName.specialAttack];

  get ivSpecialDefense => iV[StatName.specialDefense];

  get ivSpeed => iV[StatName.speed];

  //EV
  set evHp(int hp) => eV[StatName.hp] = hp;

  set evAttack(int attack) => eV[StatName.attack] = attack;

  set evDefense(int defense) => eV[StatName.defense] = defense;

  set evSpecialAttack(int specialAttack) =>
      eV[StatName.specialAttack] = specialAttack;

  set evSpecialDefence(int specialDefense) =>
      eV[StatName.specialDefense] = specialDefense;

  set evSpeed(int speed) => eV[StatName.speed] = speed;

  get evHp => eV[StatName.hp];

  get evAttack => eV[StatName.attack];

  get evDefense => eV[StatName.defense];

  get evSpecialAttack => eV[StatName.specialAttack];

  get evSpecialDefense => eV[StatName.specialDefense];

  get evSpeed => eV[StatName.speed];

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
    iV = PokemonStats.getNewInitializedMapBaseStats(initValue: 31);
    eV = PokemonStats.getNewInitializedMapBaseStats();
    level = 100;
  }

  PokemonInstance.fromMap(int dbKey, Map<String, dynamic> pokemonMap, Team team)
      : super.fromMap(dbKey, pokemonMap) {
    this.team = team;
    this.firstName = pokemonMap['firstName'];
    this.abilitySelected =
        new Ability.fromMap(jsonDecode(pokemonMap['abilitySelected']));
    this.nature = Nature(NatureName.values[pokemonMap['nature']]);
    this.level = pokemonMap['level'];

    this.iV = {};
    ivHp = pokemonMap['ivHp'];
    ivAttack = pokemonMap['ivAttack'];
    ivDefense = pokemonMap['ivDefense'];
    ivSpecialAttack = pokemonMap['ivSpecialAttack'];
    ivSpecialDefence = pokemonMap['ivSpecialDefense'];
    ivSpeed = pokemonMap['ivSpeed'];

    this.eV = {};
    evHp = pokemonMap['evHp'];
    evAttack = pokemonMap['evAttack'];
    evDefense = pokemonMap['evDefense'];
    evSpecialAttack = pokemonMap['evSpecialAttack'];
    evSpecialDefence = pokemonMap['evSpecialDefense'];
    evSpeed = pokemonMap['evSpeed'];
  }

  Map<String, dynamic> get map {
    Map<String, dynamic> returnMap = super.map;
    returnMap.addAll({
      'firstName': this.firstName,
      'teamDbKey': team.dbKey,
      'abilitySelected': jsonEncode(abilitySelected),
      'nature': nature.name.index,
      'level': this.level,
      'ivHp': ivHp,
      'ivAttack': ivAttack,
      'ivDefense': ivDefense,
      'ivSpecialAttack': ivSpecialAttack,
      'ivSpecialDefense': ivSpecialDefense,
      'ivSpeed': ivSpeed,
      'evHp': evHp,
      'evAttack': evAttack,
      'evDefense': evDefense,
      'evSpecialAttack': evSpecialAttack,
      'evSpecialDefense': evSpecialDefense,
      'evSpeed': evSpeed,
    });
    return returnMap;
  }

  //TODO shedinja ability
  int calcStat(StatName statName) {
    int value;
    if (statName == StatName.hp) {
      value = ((2 * baseHp + ivHp + (evHp / 4).truncate()) * level / 100)
              .truncate() +
          level +
          10;
    } else {
      value = (((2 * this.baseStats[statName] +
                      iV[statName] +
                      (iV[statName] / 4).truncate()) *
                  level /
                  100)
              .truncate() +
          5);
      if (nature.up == statName) value = (value * 1.1).truncate();
      if (nature.down == statName) value = (value * 0.9).truncate();
    }
    return value;
  }

  int getStatFromNameStat(StatName statName){
    switch (statName){
      case StatName.hp: return hp;
      case StatName.attack: return attack;
      case StatName.defense: return defense;
      case StatName.specialAttack: return specialAttack;
      case StatName.specialDefense: return specialDefense;
      case StatName.speed: return speed;
    }
    return 0;
  }

}
