import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/model/pokemonStats.dart';
import 'package:poke_team/model/pokemonType.dart';
import 'package:poke_team/model/pokemonTypes.dart';
import 'package:poke_team/model/team.dart';
import 'package:poke_team/model/wrinDamage.dart';
import 'package:poke_team/services/pokeCustomTheme.dart';
import 'package:poke_team/services/teamAnalysis.dart';
import 'package:poke_team/widgets/pokeTypeContainer.dart';

import 'animatedSwitcherPokemonDetails.dart';

class TeamCoverage extends StatefulWidget {
  const TeamCoverage({Key key, @required this.team}) : super(key: key);
  final Team team;

  @override
  _TeamCoverageState createState() => _TeamCoverageState();
}

class _TeamCoverageState extends State<TeamCoverage> {
  final double cellSpacing = 30.0;
  final double cellMargin = 2.0;

  double sliderDefense = 0;
  double sliderSpecialDefense = 0;
  bool enableSliderDefense = false;
  bool enableSliderSpecialDefense = false;

  bool withAbility = false;
  bool withItem = false;

  Widget getIconAlert(
    PokemonType type,
    Map<PokemonType, Map<WeaknessResistanceImmunityNormalDamage, int>>
        summaryEffect,
  ) {
    Container containerIcon;

    if (TeamAnalysis.typeWarningForWeakness(summaryEffect, type)) {
      containerIcon = Container(
        margin: EdgeInsets.only(right: 5),
        child: Icon(
          Icons.warning_amber,
          size: 28,
          color: Colors.redAccent,
        ),
      );
    } else if (TeamAnalysis.typeShieldForResistance(summaryEffect, type)) {
      containerIcon = Container(
        margin: EdgeInsets.only(right: 5),
        child: Icon(
          Icons.shield_outlined,
          size: 28,
          color: Colors.green,
        ),
      );
    } else {
      containerIcon = Container(
        margin: EdgeInsets.only(right: 5),
        child: Icon(
          Icons.check_circle_outlined,
          size: 28,
          color: Colors.white,
        ),
      );
    }
    return containerIcon;
  }

  List<PokemonInstance> pokemonListFilteredFromSlider(
      List<PokemonInstance> inputList) {
    List<PokemonInstance> outputList = [];
    inputList.forEach((pokemon) {
      bool enoughDef = !enableSliderDefense ||
          pokemon.getStatFromNameStat(StatName.defense,
                  abilityCheck: withAbility, itemCheck: withItem) >
              sliderDefense;

      bool enoughSpDef = !enableSliderSpecialDefense ||
          pokemon.getStatFromNameStat(StatName.specialDefense,
                  abilityCheck: withAbility, itemCheck: withItem) >
              sliderSpecialDefense;

      if (enoughDef && enoughSpDef) outputList.add(pokemon);
    });
    return outputList;
  }

  @override
  Widget build(BuildContext context) {
    List<PokemonType> allTypes = PokemonTypes().getAllTypes();
    List<PokemonInstance> pokemonListFiltered =
        pokemonListFilteredFromSlider(widget.team.teamMembers);

    Map<PokemonType, Map<WeaknessResistanceImmunityNormalDamage, int>>
        summaryEffect = TeamAnalysis.summaryEffectOnPokemonList(
            pokemonListFiltered,
            withAbility: withAbility);

    StatName statNameForAnimatedSwitchedPokemonDetails;
    List<StatName> statToPrint = [];
    if (enableSliderDefense && !enableSliderSpecialDefense)
      statNameForAnimatedSwitchedPokemonDetails = StatName.defense;
    if (enableSliderSpecialDefense && !enableSliderDefense)
      statNameForAnimatedSwitchedPokemonDetails = StatName.specialDefense;
    if (enableSliderDefense && enableSliderSpecialDefense) {
      statNameForAnimatedSwitchedPokemonDetails = StatName.defense;
      statToPrint.add(StatName.specialDefense);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
              children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  //alignment: Alignment.topRight,
                  child: Text(
                    'Check Ability:',
                    style: PokeCustomTheme.getValueStyle(),
                  ),
                ),
                Switch(
                  value: withAbility,
                  onChanged: (value) {
                    setState(() {
                      withAbility = value;
                    });
                  },
                  activeTrackColor: Colors.blueAccent,
                  activeColor: Colors.blueAccent,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  //alignment: Alignment.topRight,
                  child: Text(
                    'Check Item:',
                    style: PokeCustomTheme.getValueStyle(),
                  ),
                ),
                Switch(
                  value: withItem,
                  onChanged: (value) {
                    setState(() {
                      withItem = value;
                    });
                  },
                  activeTrackColor: Colors.blueAccent,
                  activeColor: Colors.blueAccent,
                ),
              ],
            ),
            SizedBox(
              height: 32,
            ),
            Column(children: [
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Slider Defence: ${enableSliderDefense ? sliderDefense.round() : ''}',
                      style: PokeCustomTheme.getValueStyle(fontSize: 18),
                    ),
                    Switch(
                      value: enableSliderDefense,
                      onChanged: (value) {
                        setState(() {
                          enableSliderDefense = value;
                          sliderDefense = 0;
                        });
                      },
                      activeTrackColor: Colors.blueAccent,
                      activeColor: Colors.blueAccent,
                    )
                  ],
                ),
              ),
              Visibility(
                visible: enableSliderDefense,
                child: Slider(
                  value: sliderDefense,
                  max: 400,
                  min: 0,
                  divisions: 20,
                  onChanged: (newValue) =>
                      setState(() => sliderDefense = newValue),
                ),
              )
            ]),
            SizedBox(
              height: 8,
            ),
            Column(children: [
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Slider Special Defence: ${enableSliderSpecialDefense ? sliderSpecialDefense.round() : ''}',
                      style: PokeCustomTheme.getValueStyle(fontSize: 18),
                    ),
                    Switch(
                      value: enableSliderSpecialDefense,
                      onChanged: (value) {
                        setState(() {
                          enableSliderSpecialDefense = value;
                          sliderSpecialDefense = 0;
                        });
                      },
                      activeTrackColor: Colors.blueAccent,
                      activeColor: Colors.blueAccent,
                    )
                  ],
                ),
              ),
              Visibility(
                visible: enableSliderSpecialDefense,
                child: Slider(
                  value: sliderSpecialDefense,
                  max: 400,
                  min: 0,
                  divisions: 20,
                  onChanged: (newValue) =>
                      setState(() => sliderSpecialDefense = newValue),
                ),
              )
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: AnimatedSwitchedPokemonDetails(
                open: enableSliderSpecialDefense || enableSliderDefense,
                pokemonList: pokemonListFiltered,
                statName: statNameForAnimatedSwitchedPokemonDetails,
                checkAbility: withAbility,
                checkItem: withItem,
                statsToPrint: statToPrint,
              ),
            ),
            SizedBox(
              height: 32,
            ),
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
                        margin:
                            new EdgeInsets.symmetric(horizontal: cellMargin),
                        child: PokeTypeContainer(
                          PokemonType('null'),
                          alternativeStringPrint: 'W\nE\nA',
                          fixWidth: cellSpacing,
                        ),
                      ),
                      Container(
                        margin:
                            new EdgeInsets.symmetric(horizontal: cellMargin),
                        child: PokeTypeContainer(
                          PokemonType('null'),
                          alternativeStringPrint: 'N\nO\nR',
                          fixWidth: cellSpacing,
                        ),
                      ),
                      Container(
                        margin:
                            new EdgeInsets.symmetric(horizontal: cellMargin),
                        child: PokeTypeContainer(
                          PokemonType('null'),
                          alternativeStringPrint: 'R\nE\nS',
                          fixWidth: cellSpacing,
                        ),
                      ),
                      Container(
                        margin:
                            new EdgeInsets.symmetric(horizontal: cellMargin),
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
                          getIconAlert(type, summaryEffect),
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
      ),
    );
  }
}
