import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/model/team.dart';
import 'package:poke_team/services/pokeApi.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({Key key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

//TODO stampare il nome del pokemon in caricamento

  static Future<Map> safeApiCall(String pokeName) async {
    Map returnMap = new Map();
    try {
      PokeApi pAPI = new PokeApi();
      returnMap['pokemon'] = await pAPI.loadByName(pokeName);
    } catch (ex) {
      returnMap['ex_code'] = 1;
    }
    returnMap['ex_code'] = 0;
    return returnMap;
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => postBuildNavigatorLoadAndPush(context));
  }

  //per evitare di pushare un nuovo widget mentre questo sta ancora buildando, cosa che genera errore,
  // mi iscrivo a una call back sull'after build.
  void postBuildNavigatorLoadAndPush(BuildContext context){
    Map input = ModalRoute.of(context).settings.arguments;
       if (input['add'] == 'true') {
         addPokemonByName(input['pokemonName'], input['team']);
       } else {
         loadPokemonFromApi(input['pokemonInstance']);
       }
  }

  void loadPokemonFromApi(PokemonInstance pokemonInstance) async {
    Navigator.pushReplacementNamed(context, '/poke',
        arguments: {'pokemon': pokemonInstance, 'add': false});
  }

  void addPokemonByName(String pokeName, Team team) async {
    if (pokeName == '' || pokeName == null) {
      Navigator.pop(context, {'ex_code': 1, 'pokemon': null});
      return;
    }
      Map safePokemonReturn = await safeApiCall(pokeName);
      Pokemon poke;
      if (safePokemonReturn['ex_code'] == 0 &&
          (poke = safePokemonReturn['pokemon']) != null) {
        PokemonInstance pokemonInstance = new PokemonInstance(poke, team, poke.name);
        dynamic addedPokemon = await Navigator.pushNamed(context, '/poke',
            arguments: {'pokemon': pokemonInstance, 'add': true});
        Navigator.pop(context, {'ex_code': 0, 'pokemon': addedPokemon});
      } else {
        Navigator.pop(context, {'ex_code': 1, 'pokemon': null});
      }
  }

  @override
  Widget build(BuildContext context) {

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
  }
}
