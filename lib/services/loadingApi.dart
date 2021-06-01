import 'dart:convert';
import 'package:http/http.dart';

class LoadingApi{

  static final urlApi = 'https://pokeapi.co/api/v2/pokemon?limit=1118'; //TODO: leggere il count da chiamata.. usare quindi un client per effettuare due chiamate sequeniali
  static final LoadingApi _instance = LoadingApi._privateConstructor();
  static List <String> _pokemonNames = [ ];
  static final bool _loaded = false;

  LoadingApi._privateConstructor();

  static Future<LoadingApi> getInstance() async{
    if(!_loaded){
      _loadAllPokemonNames();
    }
    return _instance;
  }

  static void _loadAllPokemonNames() async{
    var url = Uri.parse(urlApi);
    var response = await get(url);
    Map pokeResp = jsonDecode(response.body);
    for(dynamic poke in pokeResp['results']){
      _pokemonNames.add(poke['name']);
    }
  }

  List<String> getAllPokemonName() {
    return _pokemonNames;
  }

}




