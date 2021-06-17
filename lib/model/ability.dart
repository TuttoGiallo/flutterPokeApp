import 'package:poke_team/model/pokemonStats.dart';
import 'package:poke_team/model/pokemonType.dart';
import 'package:poke_team/model/pokemonTypes.dart';

//TODO refactor in pokemon ability
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

  static int abilityStatAlter(
      Ability ability, StatName statName, int statValue) {
    double returnValue = statValue*1.0;
    switch (ability.name) {
      case 'wonder-guard':
        if (statName == StatName.hp) returnValue = 1;
        break;
      case 'huge-power':
        if (statName == StatName.attack) returnValue *= 2;
        break;
      case 'pure-power':
        if (statName == StatName.attack) returnValue *= 2;
        break;
      case 'guts': //TODO controllo condizioni:
        if (statName == StatName.attack) returnValue *= 2;
        break;
      case 'unburden':
        if (statName == StatName.speed) returnValue *= 2;
        break;
      case 'sand-rush':
        if (statName == StatName.speed) returnValue *= 2;
        break;
      case 'sand-force':
        if (statName == StatName.attack) returnValue *= 1.3;
        break;
      case 'chlorophyll':
        if (statName == StatName.speed) returnValue *= 2;
        break;
      case 'swift-swim':
        if (statName == StatName.speed) returnValue *= 2;
        break;
      case 'solar-power':
        if (statName == StatName.specialAttack) returnValue *= 1.5;
        break;
    }
    return returnValue.round();
  }

  static double abilityDamageAlterFactorOnType(
      Ability ability, PokemonType pokemonType) {
    double factor = 1;
    switch (ability.name) {
      case 'levitate':
        factor = pokemonType == PokemonTypes.ground ? 0 : 1;
        break;
      case 'flash-fire':
        factor = pokemonType == PokemonTypes.fire ? 0 : 1;
        break;
      case 'lightning-rod':
        factor = pokemonType == PokemonTypes.electric ? 0 : 1;
        break;
      case 'sap-sipper':
        factor = pokemonType == PokemonTypes.grass ? 0 : 1;
        break;
      case 'water-absorb':
        factor = pokemonType == PokemonTypes.water ? 0 : 1;
        break;
      case 'storm-drain':
        factor = pokemonType == PokemonTypes.water ? 0 : 1;
        break;
      case 'dry-skin':
        if (pokemonType == PokemonTypes.water) factor = 0;
        if (pokemonType == PokemonTypes.fire) factor = 1.25;
        factor = 1;
        break;
      case 'volt-absorb':
        factor = pokemonType == PokemonTypes.electric ? 0 : 1;
        break;
      case 'thick-fat':
        factor =
            pokemonType == PokemonTypes.ice || pokemonType == PokemonTypes.fire
                ? 0.5
                : 1;
        break;
      case 'fluffy':
        factor = pokemonType == PokemonTypes.fire ? 2 : 1;
        break;
      case 'heatproof':
        factor = pokemonType == PokemonTypes.fire ? 0.5 : 1;
        break;
      case 'water-bubble':
        factor = pokemonType == PokemonTypes.fire ? 0.5 : 1;
        break;
      case 'wonder-guard': //TODO generalizzare, ora funziona solo nel caso (unico) di shedinja
        factor = [
          PokemonTypes.flying,
          PokemonTypes.rock,
          PokemonTypes.ghost,
          PokemonTypes.fire,
          PokemonTypes.dark
        ].contains(pokemonType)
            ? 1
            : 0;
    }
    return factor;
  }
}
