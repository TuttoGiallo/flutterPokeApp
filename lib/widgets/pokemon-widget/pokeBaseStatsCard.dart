import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/services/pokeCustomTheme.dart';

class PokeBaseStatsCard extends StatelessWidget {
  const PokeBaseStatsCard({Key key, @required this.pokemon}) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetsStats = [];
    for(BaseStatName bsName in pokemon.baseStats.keys){
      widgetsStats.add(
        Column(
        children:[ Text(Pokemon.baseStatNameToString(bsName),
            textAlign: TextAlign.left,
            style: PokeCustomTheme.getFieldStyle()),
        SizedBox(
          height: 8.0,
        ),
        SinglePokeBaseStat(stat: pokemon.baseStats[bsName]),
        SizedBox(
          height: 20.0,
        )]
        )
      );
    }
    
    return Container(
      child: SingleChildScrollView(
        child: Visibility(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50.0,20,50,0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: widgetsStats,
            ),
          ),
        ),
      ),
    );
  }
}

//TODO parametrizzare e utilizzare sia per BaseStats che per Stats
class SinglePokeBaseStat extends StatelessWidget {
  const SinglePokeBaseStat({Key key, @required this.stat}) : super(key: key);
  final int stat;

  @override
  Widget build(BuildContext context) {
    Color barColor;
    if (stat < 40)
      barColor = Colors.red;
    else if (stat < 80)
      barColor = Colors.deepOrangeAccent;
    else if (stat < 120)
      barColor = Colors.yellow;
    else if (stat < 160)
      barColor = Colors.lightGreen;
    else
      barColor = Colors.greenAccent;

    return LinearPercentIndicator(
      lineHeight: 30.0,
      percent: (100 / 200) *
          (stat > 200 ? 200 : stat)
          / 100,
      backgroundColor: Colors.grey[300],
      progressColor: barColor,
      animationDuration: 1000,
      animation: true,
      linearStrokeCap: LinearStrokeCap.roundAll,
      center: Text('$stat', style: PokeCustomTheme.getValueStyle()),
    );
  }
}
