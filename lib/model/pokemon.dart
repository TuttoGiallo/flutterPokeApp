import 'dart:convert';

import 'package:poke_team/model/ability.dart';
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
  Map<BaseStatName, int> baseStats = {
    BaseStatName.hp: 0,
    BaseStatName.attack: 0,
    BaseStatName.defense: 0,
    BaseStatName.specialAttack: 0,
    BaseStatName.specialDefence: 0,
    BaseStatName.speed: 0,
  };

  set hp(int hp) => baseStats[BaseStatName.hp] = hp;
  set attack(int attack) => baseStats[BaseStatName.attack] = attack;
  set defense(int defense) => baseStats[BaseStatName.defense] = defense;
  set specialAttack(int specialAttack) => baseStats[BaseStatName.specialAttack] = specialAttack;
  set specialDefence(int specialDefence) => baseStats[BaseStatName.specialDefence] = specialDefence;
  set speed(int speed) => baseStats[BaseStatName.speed] = speed;

  get hp => baseStats[BaseStatName.hp];
  get attack => baseStats[BaseStatName.attack];
  get defense => baseStats[BaseStatName.defense];
  get specialAttack => baseStats[BaseStatName.specialAttack];
  get specialDefence => baseStats[BaseStatName.specialDefence];
  get speed => baseStats[BaseStatName.speed];

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
    hp = pokemonMap['hp'];
    attack = pokemonMap['attack'];
    defense = pokemonMap['defense'];
    specialAttack = pokemonMap['specialAttack'];
    specialDefence = pokemonMap['specialDefence'];
    speed = pokemonMap['speed'];
  }

  Map<String, dynamic> get map {
    return {
      'id': id,
      'name': name,
      'type1': type1.name,
      'type2': type2 != null ? type2.name : '',
      'urlSprite': urlSprite,
      'abilities': jsonEncode(abilities),
      'hp': hp,
      'attack': attack,
      'defense': defense,
      'specialAttack': specialAttack,
      'specialDefence': specialDefence,
      'speed': speed,
    };
  }

  static String baseStatNameToString(BaseStatName baseStatName) {
    switch (baseStatName) {
      case BaseStatName.hp:
        return "HP";
      case BaseStatName.attack:
        return "Attack";
      case BaseStatName.defense:
        return "Defence";
      case BaseStatName.specialAttack:
        return "Special Attack";
      case BaseStatName.specialDefence:
        return "Special Defence";
      case BaseStatName.speed:
        return "Speed";
    }
    return '';
  }
}

enum BaseStatName { hp, attack, defense, specialAttack, specialDefence, speed }
