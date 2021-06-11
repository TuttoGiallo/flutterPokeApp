import 'package:poke_team/model/pokemonType.dart';
import 'package:poke_team/model/pokemonTypes.dart';

class Ability {
  String name;
  String shortEffect;
  String effect;

  bool hidden;
  int slot;

  Ability(this.name, {this.hidden, this.slot, this.shortEffect, this.effect});

  Ability.fromMap(Map<String, dynamic> abilityMap) {
    //TODO creare tabella/store separato per le abilità, così da usare solo delle referenze a esse.
    name = abilityMap['name'];
    shortEffect = abilityMap['shortEffect'];
    hidden = abilityMap['hidden'];
    slot = abilityMap['slot'];
    effect = abilityMap['effect'];
  }

  Map<String, dynamic> get map {
    return {
      'name': name,
      'shortEffect': shortEffect,
      'hidden': hidden,
      'slot': slot,
      'effect': effect,
    };
  }

  Map toJson() => this.map;

  static double abilityDamageModficatorOnType(
      Ability ability, PokemonType pokemonType) {
    double damageMod = 1;
    switch (ability.name) {
      case 'levitate':
        damageMod = pokemonType == PokemonTypes.ground ? 0 : 1;
        break;
      case 'flash-fire':
        damageMod = pokemonType == PokemonTypes.fire ? 0 : 1;
        break;
      case 'lightning-rod':
        damageMod = pokemonType == PokemonTypes.electric ? 0 : 1;
        break;
      case 'sap-sipper':
        damageMod = pokemonType == PokemonTypes.grass ? 0 : 1;
        break;
      case 'water-absorb':
        damageMod = pokemonType == PokemonTypes.water ? 0 : 1;
        break;
      case 'storm-drain':
        damageMod = pokemonType == PokemonTypes.water ? 0 : 1;
        break;
      case 'volt-absorb':
        damageMod = pokemonType == PokemonTypes.electric ? 0 : 1;
        break;
      case 'thick-fat':
        damageMod =
            pokemonType == PokemonTypes.ice || pokemonType == PokemonTypes.fire
                ? 0.5
                : 1;
        break;
      case 'fluffy':
        damageMod = pokemonType == PokemonTypes.fire ? 2 : 1;
        break;
      case 'heatproof':
        damageMod = pokemonType == PokemonTypes.fire ? 0.5 : 1;
        break;
      case 'water-bubble':
        damageMod = pokemonType == PokemonTypes.fire ? 0.5 : 1;
        break;
    }
    return damageMod;
  }
}
