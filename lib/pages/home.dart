import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:poke_team/model/team.dart';
import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/services/loaderDB.dart';
import 'package:poke_team/widgets/teamPoke.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

//TODO: creare un widget separato per la gestione visualizzazione del team
class _HomeState extends State<Home> {
  LoaderDB loaderDB = new LoaderDB();
  List<TeamPoke> teamPokelist;
  Team team = Team();
  bool loaded = false;


  final addController = TextEditingController();

  @override
  void dispose() {
    addController.dispose();
    //Clean up the controller when the widget is disposed
    super.dispose();
  }

  Function() refresh() => () {
        setState(() {});
      };

  @override
  void initState() {
    loadFromDBAsync();
    super.initState();
  }

  loadFromDBAsync() async{
    await loaderDB.loadTeam();
    loaded = true;
    setState(() {
      //TODO passare il caricamento del team qui e togliere il team come singleton!!
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) {
      return Scaffold(
        backgroundColor: Colors.amber,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(38.0),
            child: SpinKitHourGlass(
              color: Colors.grey[500],
              size: 100.0,
            ),
          ),
        ),
      );
    } else {
      addController.clear();
//TODO: togliere focus dal campo aggiunta
      Team team = Team();
      teamPokelist = [];
      for (Pokemon p in team.teamMembers) {
        teamPokelist.add(new TeamPoke(
            p,
                (Pokemon poke) =>
            {
              setState(() {
                team.removePokemon(poke);
                loaderDB.deletePokemonInTeam(poke);
              })
            }));
      }

      return Scaffold(
          appBar: AppBar(
            title: Text('Team'),
            centerTitle: true,
            backgroundColor: Colors.amber,
          ),
          body: Container(
            color: Colors.amber,
            height: double.infinity,
            //messo per far fittare lo sfondo sempre con la schermata... anche quando la scroll è minore dello schermo. TODO:testare on un tablet!
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                image: const DecorationImage(
                  image: AssetImage('assets/pika.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      Column(
                        children: teamPokelist,
                      ),
                      Visibility(
                        visible: !team.teamFull(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              border: Border.all(
                                color: Colors.amber,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                  EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 10.0),
                                  child: SizedBox(
                                    width: 250,
                                    //TODO: size fissa mi sembra una minchiata
                                    child: TextField(
                                        controller: addController,
                                        decoration: const InputDecoration(
                                            helperText: "Enter Pokemon name"),
                                        style: TextStyle(
                                          fontSize: 28.0,
                                          color: Colors.grey[800],
                                          fontStyle: FontStyle.italic,
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 0.0, 14.0, 0.0),
                                  child: FloatingActionButton(
                                    backgroundColor: Colors.amber,
                                    splashColor: Colors.yellowAccent,
                                    onPressed: () async {
                                      dynamic mapAddedPokemon =
                                      await Navigator.pushNamed(
                                          context, '/loading',
                                          arguments: {
                                            'pokeName': addController.text,
                                            'add': 'true',
                                          });
                                      if (mapAddedPokemon['ex_code'] == 1) {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title:
                                                const Text(
                                                    'Pokemon non trovato'),
                                                content: const Text(
                                                    'Il nome o l\'ID inserito non è corretto.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              ),
                                        );
                                      } else {
                                        if (mapAddedPokemon['pokemon'] != null
                                            ? true
                                            : false) {
                                          setState(() {
                                            team.addPokemon(
                                                mapAddedPokemon['pokemon']);
                                            loaderDB.insertPokeInTeam(
                                                mapAddedPokemon['pokemon']);
                                          });
                                        }
                                      }
                                    },
                                    child: Icon(
                                      Icons.add,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ));
    }
  }
}
