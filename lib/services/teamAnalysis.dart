import 'package:poke_team/model/ability.dart';
import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/model/pokemonType.dart';
import 'package:poke_team/model/pokemonTypes.dart';
import 'package:poke_team/model/team.dart';
import 'package:poke_team/model/wrinDamage.dart';

class TeamAnalysis {
  static Map<PokemonType, Map<WeaknessResistanceImmunityNormalDamage, int>>
      summaryEffectOnTeam(Team team, {bool withAbility = false}) {
    PokemonTypes pokemonTypes = PokemonTypes();
    Map<PokemonType, Map<WeaknessResistanceImmunityNormalDamage, int>>
        summaryEffects = {};
    pokemonTypes
        .getAllTypes()
        .forEach((type) => summaryEffects[type] = _getNewMapWrinDamageInt());

    for (PokemonInstance pokemon in team.teamMembers) {
      Map pokeRes = pokemonTypes.getFilteredSortedTypePokemonEffect(
          pokemon, WeaknessResistanceImmunityNormalDamage.resistance, withAbility: withAbility);
      Map pokeWea = pokemonTypes.getFilteredSortedTypePokemonEffect(
          pokemon, WeaknessResistanceImmunityNormalDamage.weakness,  withAbility: withAbility);
      Map pokeImm = pokemonTypes.getFilteredSortedTypePokemonEffect(
          pokemon, WeaknessResistanceImmunityNormalDamage.immunity,  withAbility: withAbility);
      Map pokeNor = pokemonTypes.getFilteredSortedTypePokemonEffect(
          pokemon, WeaknessResistanceImmunityNormalDamage.normal,  withAbility: withAbility);

      pokeRes.keys.forEach((resType) => summaryEffects[resType]
          [WeaknessResistanceImmunityNormalDamage.resistance] += 1);
      pokeWea.keys.forEach((weaType) => summaryEffects[weaType]
          [WeaknessResistanceImmunityNormalDamage.weakness] += 1);
      pokeImm.keys.forEach((immType) => summaryEffects[immType]
          [WeaknessResistanceImmunityNormalDamage.immunity] += 1);
      pokeNor.keys.forEach((norType) => summaryEffects[norType]
          [WeaknessResistanceImmunityNormalDamage.normal] += 1);
    }

    return summaryEffects;
  }

  static Map<WeaknessResistanceImmunityNormalDamage, int>
      _getNewMapWrinDamageInt() {
    return {
      WeaknessResistanceImmunityNormalDamage.resistance: 0,
      WeaknessResistanceImmunityNormalDamage.weakness: 0,
      WeaknessResistanceImmunityNormalDamage.immunity: 0,
      WeaknessResistanceImmunityNormalDamage.normal: 0,
    };
  }

  static bool typeWarningForWeakness(
      Map<PokemonType, Map<WeaknessResistanceImmunityNormalDamage, int>>
          summary,
      PokemonType type) {
    return summary[type][WeaknessResistanceImmunityNormalDamage.weakness] >
        (summary[type][WeaknessResistanceImmunityNormalDamage.resistance] +
            summary[type][WeaknessResistanceImmunityNormalDamage.immunity]);
  }

  static bool typeShieldForResistance(
      Map<PokemonType, Map<WeaknessResistanceImmunityNormalDamage, int>>
          summary,
      PokemonType type) {
    return summary[type][WeaknessResistanceImmunityNormalDamage.weakness] <
        (summary[type][WeaknessResistanceImmunityNormalDamage.resistance] +
            summary[type][WeaknessResistanceImmunityNormalDamage.immunity]);
  }

  static Map<PokemonType, int> typeImmunityAbility(Team team) {
    Map<PokemonType, int> mapToReturn = {};
    List<PokemonType> pokemonTypes = PokemonTypes().getAllTypes();
    for (PokemonType pokemonType in pokemonTypes) {
      mapToReturn[pokemonType] = 0;
      for (PokemonInstance pokemon in team.teamMembers) {
        if (Ability.abilityDamageAlterFactorOnType(
                pokemon.abilitySelected, pokemonType) ==
            0) {
          mapToReturn[pokemonType] += 1;
        }
      }
    }
    return mapToReturn;
  }

  static Map<PokemonType, int> typeResistanceAbility(Team team) {
    Map<PokemonType, int> mapToReturn = {};
    List<PokemonType> pokemonTypes = PokemonTypes().getAllTypes();
    for (PokemonType pokemonType in pokemonTypes) {
      mapToReturn[pokemonType] = 0;
      for (PokemonInstance pokemon in team.teamMembers) {
        if (Ability.abilityDamageAlterFactorOnType(
            pokemon.abilitySelected, pokemonType) ==
            0.5) {
          mapToReturn[pokemonType] += 1;
        }
      }
    }
    return mapToReturn;
  }


}
