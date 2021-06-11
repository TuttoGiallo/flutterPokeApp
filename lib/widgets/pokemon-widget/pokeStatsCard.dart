import 'package:flutter/material.dart';
import 'package:poke_team/model/nature.dart';
import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/model/pokemonStats.dart';
import 'package:poke_team/services/pokeCustomTheme.dart';
import 'package:poke_team/widgets/pokemon-widget/inputIvEvNumberField.dart';
import 'package:poke_team/widgets/pokemon-widget/natureCard.dart';
import 'package:poke_team/widgets/pokemon-widget/pokeHiddenPowerCard.dart';
import 'package:poke_team/widgets/pokemon-widget/singlePokeStat.dart';
import 'package:poke_team/widgets/warningTextWidget.dart';

class PokeStatsCard extends StatefulWidget {
  const PokeStatsCard(
      {Key key, @required this.pokemon, @required this.onUpdatePokemonValues})
      : super(key: key);

  final PokemonInstance pokemon;
  final Function(PokemonInstance pokemonInstance) onUpdatePokemonValues;

  @override
  _PokeStatsCardState createState() => _PokeStatsCardState();
}

class _PokeStatsCardState extends State<PokeStatsCard> {
  PokemonInstance pokemonInstance;
  Nature selectedNature;
  List<DropdownMenuItem<Nature>> dropDownNature;
  bool sumEvExceed;
  bool ivExceed;
  bool evExceed;

  @override
  void initState() {
    pokemonInstance = widget.pokemon;
    calcSumEvExceed();
    calcEvExceed();
    calcIvExceed();
    super.initState();
  }

  void calcSumEvExceed() {
    int sumEv = 0;
    pokemonInstance.eV.values.forEach((evVal) => sumEv += evVal);
    sumEvExceed = sumEv > 510;
  }

  void calcIvExceed() {
    ivExceed = false;
    for (int ivVal in pokemonInstance.iV.values) {
      if (ivExceed = ivVal > 31) return;
    }
  }

  void calcEvExceed() {
    evExceed = false;
    for (int evVal in pokemonInstance.eV.values) {
      if (evExceed = evVal > 252) return;
    }
  }

  onChanged(String changeValue, StatName statName, IVEV ivOrEv) {
    setState(() {
      int newValue = int.parse(changeValue);
      if (ivOrEv == IVEV.IV) {
        this.pokemonInstance.iV[statName] = newValue;
        calcIvExceed();
      } else {
        this.pokemonInstance.eV[statName] = newValue;
        calcEvExceed();
        calcSumEvExceed();
      }
      widget.onUpdatePokemonValues(pokemonInstance);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Nature> allNatures = Nature.getAllNatures();
    selectedNature = allNatures
        .firstWhere((nature) => pokemonInstance.nature.name == nature.name);
    dropDownNature =
        []; //TODO: spostare in init per evitare di compilare ogni volta la lista... da fare anche nella drop down ability
    allNatures.forEach((nature) {
      dropDownNature.add(DropdownMenuItem<Nature>(
          value: nature, child: NatureCard(nature: nature)));
    });

    //TODO generare mappe: textController ivStats e textController evStats

    List<Widget> widgetsStats =
        []; //TODO controllare se si può spostare nell'init!
    for (StatName statName in PokemonStats.statNamesIterable()) {
      widgetsStats.add(Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(PokemonStats.statNameToAbbreviation(statName),
                textAlign: TextAlign.left,
                style: PokeCustomTheme.getFieldStyle()),
            Row(
              children: [
                InputIvEvNumberField(
                  onChanged: onChanged,
                  ivOrEv: IVEV.IV,
                  statName: statName,
                  text: '${pokemonInstance.iV[statName]}',
                  width: 30,
                  maxLength: 2,
                  labelText: 'IV',
                  labelStyle: PokeCustomTheme.getFieldStyle(fontSize: 14),
                ),
                SizedBox(
                  width: 18,
                ),
                InputIvEvNumberField(
                  onChanged: onChanged,
                  ivOrEv: IVEV.EV,
                  statName: statName,
                  text: '${pokemonInstance.eV[statName]}',
                  width: 30,
                  maxLength: 3,
                  labelText: 'EV',
                  labelStyle: PokeCustomTheme.getFieldStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
        SinglePokeStat(
            stat: pokemonInstance.getStatFromNameStat(statName), maxValue: 500),
        SizedBox(
          height: 20.0,
        )
      ]));
    }

    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text(
                'Pokemon Nature:',
                style: PokeCustomTheme.getFieldStyle(),
              ),
            )),
            DropdownButton<Nature>(
              iconSize: 40,
              iconEnabledColor: Colors.grey[200],
              value: selectedNature,
              items: dropDownNature,
              onChanged: (nature) {
                setState(() {
                  selectedNature = nature;
                  pokemonInstance.nature = nature;
                  widget.onUpdatePokemonValues(pokemonInstance);
                });
              },
            ),
            Container(
              child: Column(
                children: [
                  Visibility(
                      visible: ivExceed || evExceed || sumEvExceed,
                      child: SizedBox(
                        height: 25,
                      )),
                  Visibility(
                      visible: ivExceed,
                      child: WarningTextWidget(text: 'IV exceed')),
                  Visibility(
                      visible: evExceed,
                      child: WarningTextWidget(text: 'EV exceed')),
                  Visibility(
                      visible: sumEvExceed,
                      child: WarningTextWidget(text: 'Sum EVs exceed')),
                ],
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50.0, 20, 50, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: widgetsStats
                    ..add(
                        PokeHiddenPowerCard(pokemonInstance: pokemonInstance)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
