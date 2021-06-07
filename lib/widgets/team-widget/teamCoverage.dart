import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemonType.dart';
import 'package:poke_team/model/pokemonTypes.dart';
import 'package:poke_team/model/team.dart';
import 'package:poke_team/model/wrinDamage.dart';
import 'package:poke_team/services/teamAnalisis.dart';
import 'package:poke_team/widgets/pokeTypeContainer.dart';

class TeamCoverage extends StatelessWidget {
  const TeamCoverage({Key key, @required this.team}) : super(key: key);
  final Team team;

  final double cellSpacing = 30.0;
  final double cellMargin = 2.0;

  //TODO: creare un widget!
  Widget getIconAllert(PokemonType type, Map<PokemonType, Map<WeaknessResistanceImmunityNormalDamage, int>> summaryEffect){
    Container containerIcon;

    if(TeamAnalysis.typeWarningForWeakness(summaryEffect, type)){
      containerIcon = Container(
        margin: EdgeInsets.only(right: 5), child: Icon(
        Icons.warning_amber,
        size: 28,
        color: Colors.redAccent,
      ),);
    }else if(TeamAnalysis.typeShieldForResistence(summaryEffect, type)){
      containerIcon = Container(
        margin: EdgeInsets.only(right: 5), child: Icon(
        Icons.shield_outlined,
        size: 28,
        color: Colors.green,
      ),);
    }else{
      containerIcon = Container(
        margin: EdgeInsets.only(right: 5), child: Icon(
        Icons.check_circle_outlined,
        size: 28,
        color: Colors.white,
      ),);
    }
    return containerIcon;
  }


  @override
  Widget build(BuildContext context) {
    List<PokemonType> allTypes = PokemonTypes().getAllTypes();
    Map<PokemonType, Map<WeaknessResistanceImmunityNormalDamage, int>>
        summaryEffect = TeamAnalysis.summaryEffectOnTeam(team);
    return SingleChildScrollView(
      child: Container(
        child: Column(
            children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: PokeTypeContainer(
                    PokemonType('null'),
                    alternativeStringPrint: 'TYPE:',
                  ), // questa è logicamente una cagnata
                ),
                Row(
                  children: [
                    Container(
                      margin: new EdgeInsets.symmetric(horizontal: cellMargin),
                      child: PokeTypeContainer(
                        PokemonType('null'),
                        alternativeStringPrint: 'W\nE\nA',
                        fixWidth: cellSpacing,
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.symmetric(horizontal: cellMargin),
                      child: PokeTypeContainer(
                        PokemonType('null'),
                        alternativeStringPrint: 'N\nO\nR',
                        fixWidth: cellSpacing,
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.symmetric(horizontal: cellMargin),
                      child: PokeTypeContainer(
                        PokemonType('null'),
                        alternativeStringPrint: 'R\nE\nS',
                        fixWidth: cellSpacing,
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.symmetric(horizontal: cellMargin),
                      child: PokeTypeContainer(
                        PokemonType('null'),
                        alternativeStringPrint: 'I\nM\nM',
                        fixWidth: cellSpacing,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ]..addAll(
                allTypes.map((type) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getIconAllert(type, summaryEffect),
                        //TODO aggiungere resistenze e debolezze doppie...
                        Expanded(child: PokeTypeContainer(type)),
                        Row(
                          children: [
                            Container(
                              margin: new EdgeInsets.symmetric(
                                  horizontal: cellMargin),
                              child: PokeTypeContainer(type,
                                  alternativeStringPrint:
                                      '${summaryEffect[type][WeaknessResistanceImmunityNormalDamage.weakness]}',
                                  fixWidth: cellSpacing),
                            ),
                            Container(
                              margin: new EdgeInsets.symmetric(
                                  horizontal: cellMargin),
                              child: PokeTypeContainer(type,
                                  alternativeStringPrint:
                                      '${summaryEffect[type][WeaknessResistanceImmunityNormalDamage.normal]}',
                                  fixWidth: cellSpacing),
                            ),
                            Container(
                              margin: new EdgeInsets.symmetric(
                                  horizontal: cellMargin),
                              child: PokeTypeContainer(type,
                                  alternativeStringPrint:
                                      '${summaryEffect[type][WeaknessResistanceImmunityNormalDamage.resistance]}',
                                  fixWidth: cellSpacing),
                            ),
                            Container(
                              margin: new EdgeInsets.symmetric(
                                  horizontal: cellMargin),
                              child: PokeTypeContainer(type,
                                  alternativeStringPrint:
                                      '${summaryEffect[type][WeaknessResistanceImmunityNormalDamage.immunity]}',
                                  fixWidth: cellSpacing),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              )),
      ),
    );
  }
}