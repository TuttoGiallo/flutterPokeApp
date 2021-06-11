import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:poke_team/services/pokeCustomTheme.dart';


//TODO parametrizzare e utilizzare sia per BaseStats che per Stats
class SinglePokeStat extends StatelessWidget {
  const SinglePokeStat({Key key, @required this.stat, this.maxValue = 100}) : super(key: key);
  final int stat;
  final int maxValue;


  @override
  Widget build(BuildContext context) {
    Color barColor;
    if (stat < maxValue/5)
      barColor = Colors.red;
    else if (stat < 2*maxValue/5)
      barColor = Colors.deepOrangeAccent;
    else if (stat < 3*maxValue/5)
      barColor = Colors.yellow;
    else if (stat < 4*maxValue/5)
      barColor = Colors.lightGreen;
    else
      barColor = Colors.greenAccent;

    return LinearPercentIndicator(
      lineHeight: 30.0,
      percent: (100 / maxValue) *
          (stat > maxValue ? maxValue : stat)
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