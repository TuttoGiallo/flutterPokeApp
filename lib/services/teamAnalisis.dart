import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/model/pokemonType.dart';
import 'package:poke_team/model/pokemonTypes.dart';
import 'package:poke_team/model/team.dart';
import 'package:poke_team/model/wrinDamage.dart';

class TeamAnalysis {
  static Map<PokemonType, Map<WeaknessResistanceImmunityNormalDamage, int>> summaryEffectOnTeam(Team team) {
    PokemonTypes pokemonTypes = PokemonTypes();
    Map<PokemonType, Map<WeaknessResistanceImmunityNormalDamage, int>> summaryEffects = {};
    pokemonTypes
        .getAllTypes()
        .forEach((type) => summaryEffects[type] = _getNewMapWrinDamageInt());

    for (Pokemon pokemon in team.teamMembers) {
      Map pokeRes = pokemonTypes.getFilteredSortedTypePokemonEffect(
          pokemon, WeaknessResistanceImmunityNormalDamage.resistance);
      Map pokeWea = pokemonTypes.getFilteredSortedTypePokemonEffect(
          pokemon, WeaknessResistanceImmunityNormalDamage.weakness);
      Map pokeImm = pokemonTypes.getFilteredSortedTypePokemonEffect(
          pokemon, WeaknessResistanceImmunityNormalDamage.immunity);
      Map pokeNor = pokemonTypes.getFilteredSortedTypePokemonEffect(
          pokemon, WeaknessResistanceImmunityNormalDamage.normal);

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
  static bool typeWarningForWeakness(Map<PokemonType, Map<WeaknessResistanceImmunityNormalDamage, int>> summary, PokemonType type){
    return summary[type][WeaknessResistanceImmunityNormalDamage.weakness] >
        (summary[type][WeaknessResistanceImmunityNormalDamage.resistance] +
            summary[type][WeaknessResistanceImmunityNormalDamage.immunity]);
  }

  static bool typeShieldForResistence(Map<PokemonType, Map<WeaknessResistanceImmunityNormalDamage, int>> summary, PokemonType type){
    return summary[type][WeaknessResistanceImmunityNormalDamage.weakness] <
        (summary[type][WeaknessResistanceImmunityNormalDamage.resistance] +
            summary[type][WeaknessResistanceImmunityNormalDamage.immunity]);
  }
}
