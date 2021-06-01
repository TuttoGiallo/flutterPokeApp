import 'package:poke_team/model/ability.dart';
import 'package:poke_team/model/pokemonType.dart';
import 'package:poke_team/model/pokemonTypes.dart';

class Pokemon {
  String name;
  int id;

  //usata per identificare più pokemon dello stesso tipo nello stesso team, valorizzata da DB - 0 valore di default
  int key = -1;

  bool isStored() => this.key != -1;

  PokemonType type1;
  PokemonType type2;

  String urlSprite;

  List<Ability> abilities;

  //Base Stats:
  Map <BaseStatName, int> baseStats = {
    BaseStatName.hp: 0,
    BaseStatName.attack: 0,
    BaseStatName.defense: 0,
    BaseStatName.specialAttack: 0,
    BaseStatName.specialDefence: 0,
    BaseStatName.speed: 0,
  };


  Pokemon({this.name, this.id, this.type1, this.type2}){
    this.abilities = [];
  }

  Pokemon.fromStringType(this.name, {this.id, String type1, String type2}) {
    this.type1 = PokemonTypes().getTypeFromName(type1 ?? '');
    this.type2 = PokemonTypes().getTypeFromName(type2 ?? '');
  }

  Pokemon.fromMap(this.key, Map<String, dynamic> pokemonMap) {
    id = pokemonMap['id'];
    name = pokemonMap['name'];
    type1 = PokemonTypes().getTypeFromName(pokemonMap['type1']);
    type2 = PokemonTypes().getTypeFromName(pokemonMap['type2']);
    urlSprite = pokemonMap['urlSprite'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type1': type1.name,
      'type2': type2 != null ? type2.name : '',
      'urlSprite': urlSprite,
    };
  }

  static String baseStatNameToString(BaseStatName baseStatName){
    switch (baseStatName){
      case BaseStatName.hp: return "HP";
      case BaseStatName.attack: return "Attack";
      case BaseStatName.defense: return "Defence";
      case BaseStatName.specialAttack: return "Special Attack";
      case BaseStatName.specialDefence: return "Special Defence";
      case BaseStatName.speed: return "Speed";
    }
    return '';
  }
}

enum BaseStatName { hp, attack, defense, specialAttack, specialDefence, speed }
