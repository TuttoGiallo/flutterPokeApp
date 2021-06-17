import 'dart:convert';

import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/model/pokemonItem.dart';
import 'package:poke_team/model/pokemonStats.dart';
import 'package:poke_team/model/pokemonType.dart';
import 'package:poke_team/model/pokemonTypes.dart';
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

  PokemonItem item;

  int get hpWithAbilityAndItem => PokemonItem.itemStatAlter(item, StatName.hp,
      Ability.abilityStatAlter(this.abilitySelected, StatName.hp, hp));

  int get attackWithAbilityAndItem => PokemonItem.itemStatAlter(
      item,
      StatName.attack,
      Ability.abilityStatAlter(this.abilitySelected, StatName.attack, attack));

  int get defenseWithAbilityAndItem => PokemonItem.itemStatAlter(
      item,
      StatName.defense,
      Ability.abilityStatAlter(
          this.abilitySelected, StatName.defense, defense));

  int get specialAttackWithAbilityAndItem => PokemonItem.itemStatAlter(
      item,
      StatName.specialAttack,
      Ability.abilityStatAlter(
          this.abilitySelected, StatName.specialAttack, specialAttack));

  int get specialDefenseWithAbilityAndItem => PokemonItem.itemStatAlter(
      item,
      StatName.specialDefense,
      Ability.abilityStatAlter(
          this.abilitySelected, StatName.specialDefense, specialDefense));

  int get speedWithAbilityAndItem => PokemonItem.itemStatAlter(
      item,
      StatName.speed,
      Ability.abilityStatAlter(this.abilitySelected, StatName.speed, speed));

  int get hpWithItem => PokemonItem.itemStatAlter(this.item, StatName.hp, hp);

  int get attackWithItem =>
      PokemonItem.itemStatAlter(this.item, StatName.attack, attack);

  int get defenseWithItem =>
      PokemonItem.itemStatAlter(this.item, StatName.defense, defense);

  int get specialAttackWithItem => PokemonItem.itemStatAlter(
      this.item, StatName.specialAttack, specialAttack);

  int get specialDefenseWithItem => PokemonItem.itemStatAlter(
      this.item, StatName.specialDefense, specialDefense);

  int get speedWithItem =>
      PokemonItem.itemStatAlter(this.item, StatName.speed, speed);

  int get hpWithAbility =>
      Ability.abilityStatAlter(this.abilitySelected, StatName.hp, hp);

  int get attackWithAbility =>
      Ability.abilityStatAlter(this.abilitySelected, StatName.attack, attack);

  int get defenseWithAbility =>
      Ability.abilityStatAlter(this.abilitySelected, StatName.defense, defense);

  int get specialAttackWithAbility => Ability.abilityStatAlter(
      this.abilitySelected, StatName.specialAttack, specialAttack);

  int get specialDefenseWithAbility => Ability.abilityStatAlter(
      this.abilitySelected, StatName.specialDefense, specialDefense);

  int get speedWithAbility =>
      Ability.abilityStatAlter(this.abilitySelected, StatName.speed, speed);

  int get hp => calcStat(StatName.hp);

  int get attack => calcStat(StatName.attack);

  int get defense => calcStat(StatName.defense);

  int get specialAttack => calcStat(StatName.specialAttack);

  int get specialDefense => calcStat(StatName.specialDefense);

  int get speed => calcStat(StatName.speed);

  //IV
  set ivHp(int hp) => iV[StatName.hp] = hp;

  set ivAttack(int attack) => iV[StatName.attack] = attack;

  set ivDefense(int defense) => iV[StatName.defense] = defense;

  set ivSpecialAttack(int specialAttack) =>
      iV[StatName.specialAttack] = specialAttack;

  set ivSpecialDefence(int specialDefense) =>
      iV[StatName.specialDefense] = specialDefense;

  set ivSpeed(int speed) => iV[StatName.speed] = speed;

  int get ivHp => iV[StatName.hp];

  int get ivAttack => iV[StatName.attack];

  int get ivDefense => iV[StatName.defense];

  int get ivSpecialAttack => iV[StatName.specialAttack];

  int get ivSpecialDefense => iV[StatName.specialDefense];

  int get ivSpeed => iV[StatName.speed];

  //EV
  set evHp(int hp) => eV[StatName.hp] = hp;

  set evAttack(int attack) => eV[StatName.attack] = attack;

  set evDefense(int defense) => eV[StatName.defense] = defense;

  set evSpecialAttack(int specialAttack) =>
      eV[StatName.specialAttack] = specialAttack;

  set evSpecialDefence(int specialDefense) =>
      eV[StatName.specialDefense] = specialDefense;

  set evSpeed(int speed) => eV[StatName.speed] = speed;

  int get evHp => eV[StatName.hp];

  int get evAttack => eV[StatName.attack];

  int get evDefense => eV[StatName.defense];

  int get evSpecialAttack => eV[StatName.specialAttack];

  int get evSpecialDefense => eV[StatName.specialDefense];

  int get evSpeed => eV[StatName.speed];

  PokemonType get hiddenPowerType {
    int numberHP = ((ivHp % 2 +
                2 * (ivAttack % 2) +
                4 * (ivDefense % 2) +
                8 * (ivSpeed % 2) +
                16 * (ivSpecialAttack % 2) +
                32 * (ivSpecialDefense % 2)) *
            15 /
            63)
        .truncate();
    return PokemonTypes.getHiddenPowerType(numberHP);
  }

  int get hiddenPowerDamage {
    return ((_getSecondLastSignificantBit(ivHp) +
                    2 * _getSecondLastSignificantBit(ivAttack) +
                    4 * _getSecondLastSignificantBit(ivDefense) +
                    8 * _getSecondLastSignificantBit(ivSpeed) +
                    16 * _getSecondLastSignificantBit(ivSpecialAttack) +
                    32 * _getSecondLastSignificantBit(ivSpecialDefense)) *
                40 /
                63)
            .truncate() +
        30;
  }

  int _getSecondLastSignificantBit(int value) {
    int remainder = value % 4;
    return remainder == 3 || remainder == 2 ? 1 : 0;
  }

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

    this.item = pokemonMap['item'] != 'null'
        ? PokemonItem.fromMap(jsonDecode(pokemonMap['item']))
        : null;

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
      'item': jsonEncode(item),
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

  Map toJson() => this.map..remove('teamDbKey');

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
                      (eV[statName] / 4).truncate()) *
                  level /
                  100)
              .truncate() +
          5);
      if (nature.up == statName) value = (value * 1.1).truncate();
      if (nature.down == statName) value = (value * 0.9).truncate();
    }
    return value;
  }

  int getStatFromNameStat(StatName statName,
      {bool abilityCheck = false, bool itemCheck = false}) {
    int returnValue = 0;
    switch (statName) {
      case StatName.hp:
        if (abilityCheck && !itemCheck) returnValue = hpWithAbility;
        if (itemCheck && !abilityCheck) returnValue = hpWithItem;
        if (abilityCheck && itemCheck)  returnValue = hpWithAbilityAndItem;
        if (!abilityCheck && !itemCheck)returnValue = hp;
        break;
      case StatName.attack:
        if (abilityCheck && !itemCheck) returnValue = attackWithAbility;
        if (itemCheck && !abilityCheck) returnValue = attackWithItem;
        if (abilityCheck && itemCheck) returnValue = attackWithAbilityAndItem;
        if (!abilityCheck && !itemCheck)returnValue = attack;
        break;
      case StatName.defense:
        if (abilityCheck && !itemCheck) returnValue = defenseWithAbility;
        if (itemCheck && !abilityCheck) returnValue = defenseWithItem;
        if (abilityCheck && itemCheck) returnValue = defenseWithAbilityAndItem;
        if (!abilityCheck && !itemCheck)returnValue = defense;
        break;
      case StatName.specialAttack:
        if (abilityCheck && !itemCheck) returnValue = specialAttackWithAbility;
        if (itemCheck && !abilityCheck) returnValue = specialAttackWithItem;
        if (abilityCheck && itemCheck)
          returnValue = specialAttackWithAbilityAndItem;
        if (!abilityCheck && !itemCheck)returnValue = specialAttack;
        break;
      case StatName.specialDefense:
        if (abilityCheck && !itemCheck) returnValue = specialDefenseWithAbility;
        if (itemCheck && !abilityCheck) returnValue = specialDefenseWithItem;
        if (abilityCheck && itemCheck)
          returnValue = specialDefenseWithAbilityAndItem;
        if (!abilityCheck && !itemCheck)returnValue = specialDefense;
        break;
      case StatName.speed:
        if (abilityCheck && !itemCheck) returnValue = speedWithAbility;
        if (itemCheck && !abilityCheck) returnValue = speedWithItem;
        if (abilityCheck && itemCheck) returnValue = speedWithAbilityAndItem;
        if (!abilityCheck && !itemCheck)returnValue = speed;
        break;
    }
    return returnValue;
  }
}
