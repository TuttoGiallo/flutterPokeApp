import 'package:flutter/cupertino.dart';
import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/model/wrinDamage.dart';
import 'package:poke_team/services/pokeCustomTheme.dart';
import 'package:poke_team/widgets/pokeTypeXFactorList.dart';

class PokeTypesEffectCard extends StatelessWidget {
  const PokeTypesEffectCard({Key key, @required this.poke}) : super(key: key);
  final Pokemon poke;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Weakness:', style: PokeCustomTheme.getFieldStyle()),
            SizedBox(
              height: 8.0,
            ),
            PokeTypeXFactorList(
                this.poke, WeaknessResistanceImmunityNormalDamage.weakness),
            SizedBox(
              height: 34.0,
            ),
            Text('Resistance:', style: PokeCustomTheme.getFieldStyle()),
            SizedBox(
              height: 8.0,
            ),
            PokeTypeXFactorList(
                this.poke, WeaknessResistanceImmunityNormalDamage.resistance),
            SizedBox(
              height: 34.0,
            ),
            Text('Immunity:', style: PokeCustomTheme.getFieldStyle()),
            SizedBox(
              height: 8.0,
            ),
            PokeTypeXFactorList(
                this.poke, WeaknessResistanceImmunityNormalDamage.immunity),
            SizedBox(
              height: 34.0,
            ),
          ],
        ),
      ),
    );
  }
}
