import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:poke_team/model/team.dart';
import 'package:poke_team/model/pokemon.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class LoaderDB{

  //factory usata per aprire il DB
  DatabaseFactory dbFactory = databaseFactoryIo;
  Database _db;

  //TABELLA TEAM: associazione key - Map che rappresenta i valori storati.
  final storeTeam = intMapStoreFactory.store('team');

  Future<Database> init() async{
    if(_db == null){
      await _opendDb().then((db) => _db = db);
    }
    return _db;
  }

  Future _opendDb() async{
    //path_provider  ricerca percorso della cartella documenti dell'applicazione.
    final percorsoDocumenti = await getApplicationDocumentsDirectory();
    //il metodo join di path.dart serve per inserire il corretto separatore a seconda del sistema iOS e Android
    final percorsoDb = join(percorsoDocumenti.path, 'team.db');
    //apertura database
    final db = await dbFactory.openDatabase(percorsoDb);
    return db;
  }

  Map<String, dynamic> transformPokemonInDBMap(Pokemon pokemon){
    String jsonPokemon = jsonEncode(pokemon);
    return {pokemon.name: jsonPokemon}; //TODO: cambiare la key di salvataggio per permettere di mettere due pokemon dello stesso tipo nel team
  }

  Future<int> insertPokeInTeam(Pokemon pokemon) async{
    if(_db == null){
      await init();
    }
    int id = await storeTeam.add(_db, pokemon.toMap());
    return id;
  }

  Future<List<Pokemon>> loadPokemons() async {
    if (_db == null) {
      await init();
    }
    final finder = Finder(sortOrders: [
        SortOrder('id'),
    ]);

    final pokemonsSnapshot = await storeTeam.find(_db, finder: finder);
    List<Pokemon> pokemons = [];
    for(RecordSnapshot pokemonRecord in pokemonsSnapshot){
      pokemons.add(Pokemon.fromMap(pokemonRecord.key, pokemonRecord.value));
    }
    return pokemons;
  }

  Future<void> loadTeam() async {
    Team team = Team();
    team.teamMembers.addAll(await loadPokemons());
  }

  Future<void> deletePokemonInTeam(Pokemon pokemon) async{
    final finder = Finder(filter: Filter.byKey(pokemon.key));
    await storeTeam.delete(_db, finder: finder);
  }

  Future<Pokemon> readSinglePokemonByKey(int key) async{
    final finder = Finder(filter: Filter.byKey(key));
    final recordPokemon = await storeTeam.findFirst(_db, finder: finder);
    if(recordPokemon == null){
      return null;
    }
    return Pokemon.fromMap(key, recordPokemon.value);
  }

  Future resetDb() async{
    await storeTeam.delete(_db);
  }

  //TODO update quando i pokemon saranno parametrizzati...
}