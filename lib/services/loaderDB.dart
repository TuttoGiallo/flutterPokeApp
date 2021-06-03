import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/model/team.dart';
import 'package:poke_team/model/teamV1.dart';
import 'package:poke_team/model/pokemon.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class LoaderDB {
  static final LoaderDB _instance = LoaderDB._privateConstructor();

  //costruttore privato
  LoaderDB._privateConstructor();

  factory LoaderDB() {
    return _instance;
  }

  //factory usata per aprire il DB
  DatabaseFactory dbFactory = databaseFactoryIo;
  Database _db;

  //TABELLA TEAM: associazione key - Map che rappresenta i valori storati.
  final storePokemon = intMapStoreFactory
      .store('pokemon'); //il pokemon punta al team al quale è associato.
  final storeTeams = intMapStoreFactory
      .store('teams'); //TODO: valutare univocità forzata nomi team

  Future<Database> init() async {
    if (_db == null) {
      await _opendDb().then((db) => _db = db);
    }
    return _db;
  }

  Future _opendDb() async {
    //path_provider  ricerca percorso della cartella documenti dell'applicazione.
    final percorsoDocumenti = await getApplicationDocumentsDirectory();
    //il metodo join di path.dart serve per inserire il corretto separatore a seconda del sistema iOS e Android
    final percorsoDb = join(percorsoDocumenti.path, 'pokeApp.db');
    //apertura database
    final db = await dbFactory.openDatabase(percorsoDb);
    return db;
  }

  Future<List<Team>> loadTeams() async {
    if (_db == null) {
      await init();
    }
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);
    final teamsSnapshot = await storeTeams.find(_db, finder: finder);
    List<Team> teamList = [];
    for (RecordSnapshot teamRecord in teamsSnapshot) {
      teamList.add(Team.fromMap(teamRecord.key, teamRecord.value));
    }
    for (Team team in teamList) {
      loadAllPokemonFromTeam(team)
          .then((pokemonListOfTeam) => team.teamPokemon = pokemonListOfTeam);
    }
    return teamList;
  }

  Future<List<PokemonInstance>> loadAllPokemonFromTeam(Team team) async {
    if (_db == null) {
      await init();
    }
    final finder = Finder(filter: Filter.equals('teamDbKey', team.dbKey));
    final pokemonSnapshot = await storePokemon.find(_db, finder: finder);
    List<PokemonInstance> pokemonList = [];
    for (RecordSnapshot pokemonRecord in pokemonSnapshot) {
      pokemonList.add(PokemonInstance.fromMap(pokemonRecord.key, pokemonRecord.value, team));
    }
    return pokemonList;
  }

  //store a team without pokemon members
  Future<int> storeNewTeam(Team team) async {
    if (_db == null) {
      await init();
    }
    int id = await storeTeams.add(_db, team.map);
    team.dbKey = id;
    return id;
  }

  Future<int> storePokemonInstanceInTeam(PokemonInstance pokemon) async {
    if (_db == null) {
      await init();
    }
    int id = await storePokemon.add(_db, pokemon.map);
    return id;
  }

  @deprecated
  Map<String, dynamic> transformPokemonInDBMap(Pokemon pokemon) {
    String jsonPokemon = jsonEncode(pokemon);
    return {
      pokemon.name: jsonPokemon
    }; //TODO: cambiare la key di salvataggio per permettere di mettere due pokemon dello stesso tipo nel team
  }

  @deprecated
  Future<int> insertPokeInTeam(Pokemon pokemon, Team team) async {
    if (_db == null) {
      await init();
    }

    int id = await storePokemon.add(_db, pokemon.map);
    return id;
  }

  @deprecated
  Future<List<Pokemon>> loadPokemons() async {
    if (_db == null) {
      await init();
    }
    final finder = Finder(sortOrders: [
      SortOrder('id'),
    ]);

    final pokemonsSnapshot = await storePokemon.find(_db, finder: finder);
    List<Pokemon> pokemons = [];
    for (RecordSnapshot pokemonRecord in pokemonsSnapshot) {
      pokemons.add(Pokemon.fromMap(pokemonRecord.key, pokemonRecord.value));
    }
    return pokemons;
  }

  @deprecated
  Future<void> loadTeam() async {
    TeamV1 team = TeamV1();
    team.teamMembers.addAll(await loadPokemons());
  }

  @deprecated
  Future<void> deletePokemonInTeam(Pokemon pokemon) async {
    final finder = Finder(filter: Filter.byKey(pokemon.dbKey));
    await storePokemon.delete(_db, finder: finder);
  }

  @deprecated //TODO upgrade finder to search in a team! forse con la key non è necessari....
  Future<Pokemon> readSinglePokemonByKey(int key) async {
    final finder = Finder(filter: Filter.byKey(key));
    final recordPokemon = await storePokemon.findFirst(_db, finder: finder);
    if (recordPokemon == null) {
      return null;
    }
    return Pokemon.fromMap(key, recordPokemon.value);
  }

  Future resetDb() async {
    await storeTeams.delete(_db);
    await storePokemon.delete(_db);
  }

  Future resetPokemon() async {
    await storePokemon.delete(_db); //TODO controllare se funzione
  }

  Future resetTeams() async {
    await storeTeams.delete(_db);
  }

//TODO update quando i pokemon saranno parametrizzati...
}
