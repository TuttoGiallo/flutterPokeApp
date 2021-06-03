import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:poke_team/services/loaderDB.dart';
import 'package:poke_team/services/loadingApi.dart';

class PokeApp extends StatefulWidget {
  const PokeApp({Key key}) : super(key: key);

  @override
  _PokeAppState createState() => _PokeAppState();
}

class _PokeAppState extends State<PokeApp> {
  bool loading = false;

  void loadTeamsFromDb(BuildContext context) {
    LoaderDB loaderDb = LoaderDB();
    loaderDb.loadTeams().then((teamList) => Navigator.pushReplacementNamed(
        context, '/teams',
        arguments: teamList));
  }

  @override
  Widget build(BuildContext context) {
    if (!loading) { //TODO capire il motivo per il quale se toglo questo if idiota chiama due volte il load e il build! -- sarebbe da mettere stateLess per altro..
      loading = true;
      LoadingApi.loadAllPokemonNames();
      loadTeamsFromDb(context);
    }

    return Scaffold(
      backgroundColor: Colors.amber,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[800],
            image: const DecorationImage(
              image: AssetImage('assets/pokeball.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(38.0),
            child: SpinKitRipple(
              color: Colors.amber,
              size: 180.0,
              borderWidth: 20,
              duration: Duration(milliseconds: 1500),
            ),
          ),
        ),
      ),
    );
  }
}