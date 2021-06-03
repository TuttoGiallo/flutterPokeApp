import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:poke_team/model/teamV1.dart';
import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/services/loaderDB.dart';
import 'package:poke_team/services/loadingApi.dart';
import 'package:poke_team/widgets/pokeElement.dart';
import 'package:poke_team/widgets/teamWidgetV1.dart';
import 'package:poke_team/widgets/teamPoke.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

//TODO: creare un widget separato per la gestione visualizzazione del team
class _HomeState extends State<Home> {
  LoaderDB loaderDB = new LoaderDB(); //TODO: cambiare in singleton!
  List<TeamPoke> teamPokelist;
  List<PokeElement> teamPokeElementList;
  List<String> allPokemonName;
  TeamV1 team = TeamV1();
  bool loaded = false;

  Function() refresh() => () {
        setState(() {});
      };

  @override
  void initState() {
    loadFromDBAsync();
    super.initState();
  }

  loadFromDBAsync() async {
    await loaderDB.loadTeam();
    await LoadingApi.getInstance().then((instanceLoadingApi) =>
        allPokemonName = LoadingApi.getAllPokemonName());
    loaded = true;
    setState(() {
      //TODO passare il caricamento del team qui e togliere il team come singleton!!
    });
  }

  onAddPokemon(String pokemonNameOrId) async {
    dynamic mapAddedPokemon =
        await Navigator.pushNamed(context, '/loading', arguments: {
      'pokeName': pokemonNameOrId,
      'add': 'true',
    });
    if (mapAddedPokemon['ex_code'] == 1) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Pokemon non trovato'),
          content: const Text('Il nome o l\'ID inserito non è corretto.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      if (mapAddedPokemon['pokemon'] != null ? true : false) {
        setState(() {
          team.addPokemon(mapAddedPokemon['pokemon']);
          //loaderDB.insertPokeInTeam(mapAddedPokemon['pokemon'],); TODO correggere questa istruzione dopo la modifica del loader per la gestione di più team
        });
      }
    }
  }

  onPokemonTapForInfo(Pokemon pokemon) async {
    await Navigator.pushNamed(context, '/loading',
        arguments: {'pokeName': pokemon.name, 'add': 'false'}); //TODO quando sarà paremetrizzato non si potrà passare il nome ma si dovrà passare l'intero pokemon
  }

  onDeletePokemonFromTeam(Pokemon pokemon){
    team.removePokemon(pokemon);
    loaderDB.deletePokemonInTeam(pokemon);
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
      // addController.clear(); TODO clear?!
      //TODO: togliere focus dal campo aggiunta
      TeamV1 team = TeamV1(); //TODO: togliere la singleton team
      teamPokelist = [];
      for (Pokemon p in team.teamMembers) {
        PageStorageKey key = new PageStorageKey(p);
        teamPokelist.add(new TeamPoke(key: key,
            poke: p,
            deletePokemonFunctionCallBack: (Pokemon poke) => {
                  setState(() {
                    team.removePokemon(poke);
                    loaderDB.deletePokemonInTeam(poke);
                  })
                }));
      }

      teamPokeElementList = [];
      for(Pokemon p in team.teamMembers) {
        PageStorageKey key = new PageStorageKey(p);
        teamPokeElementList.add(new PokeElement(key: key,
            poke: p,
            deletePokemonFunctionCallBack: (Pokemon poke) => {
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
          body: TeamWidgetV1(team: team, allPokemonName: allPokemonName, onAddPokemonInTeam: onAddPokemon, onPokemonTapForInfo: onPokemonTapForInfo, onDeletePokemonFromTeam: onDeletePokemonFromTeam,),

      );
     /*     Container(
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
                      Visibility(
                        visible: !team.teamFull(),
                        child: AddPokemonInTeam(allPokemonName: allPokemonName, onAddPokemonConfirm: onAddPokemon),
                      ),
                      Column(children: teamPokelist),
                    ],
                  ),
                ),
              ),
            ),
          ));*/
    }
  }
}
