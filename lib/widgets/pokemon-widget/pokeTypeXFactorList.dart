import 'package:flutter/cupertino.dart';
import 'package:fraction/fraction.dart';
import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/model/pokemonType.dart';
import 'package:poke_team/model/pokemonTypes.dart';
import 'package:poke_team/model/wrinDamage.dart';
import 'package:poke_team/services/pokeCustomTheme.dart';
import 'package:poke_team/widgets/pokemon-widget/pokeTypeContainer.dart';
//TODO: import cartella intera

class PokeTypeXFactorList extends StatelessWidget {
  const PokeTypeXFactorList(this.pokemon, this.wrinDamage, {Key key}) : super(key: key);
  final Pokemon pokemon;
  final WeaknessResistanceImmunityNormalDamage wrinDamage;

  @override
  Widget build(BuildContext context) {
    List<Widget> typeWidgets = [];
    Map<PokemonType, double> pokemonTypesEffectList =
    PokemonTypes().getFilteredSortedTypePokemonEffect(pokemon, wrinDamage);
    for (PokemonType eType in pokemonTypesEffectList.keys) {
      typeWidgets.add(Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: PokeTypeContainer(eType)),
            SizedBox(
              width: 10,
            ),
            Text(
              'X ${Fraction.fromDouble(pokemonTypesEffectList[eType])}',
              style: PokeCustomTheme.getValueStyle(),
            ),
          ]),
          SizedBox(
            height: 3,
          ),
        ],
      ));
    }
    return Column(children: typeWidgets);
  }
}
