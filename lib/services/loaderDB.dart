import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/model/pokemonItem.dart';
import 'package:poke_team/model/team.dart';
import 'package:poke_team/model/pokemon.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class LoaderDB {
  static final LoaderDB _instance = LoaderDB._privateConstructor();
  static bool _loadedTeams = false;

  List<Team> _pokemonTeamsLoadedFromDB = [];

  //costruttore privato
  LoaderDB._privateConstructor();

  factory LoaderDB() {
    if (!_loadedTeams) {
      _instance._loadTeams().then((teamList) => _loadedTeams = true);
    }
    return _instance;
  }

  //factory usata per aprire il DB
  DatabaseFactory dbFactory = databaseFactoryIo;
  Database _db;

  //TABELLA TEAM: associazione key - Map che rappresenta i valori storati.
  final _storePokemon = intMapStoreFactory
      .store('pokemon'); //il pokemon punta al team al quale è associato.
  final _storeTeams = intMapStoreFactory.store('teams');
  final _storeItems = intMapStoreFactory.store('items');

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

  List<Team> getAllTeamsFromLastDBLoad() {
    return _pokemonTeamsLoadedFromDB;
  }

  static Future awaitLoadingInstance() async {
    Completer completer = new Completer();
    _readLoadingValues()
        .listen((cycleNumber) => print('loaderDB cycleNumber: $cycleNumber'),
            onDone: () {
      print('completer DB complete');
      completer.complete();
    });
    return completer.future;
  }

//TODO lanciare errori...
  static Stream<int> _readLoadingValues(
      {intervalMillisecond = 300, int maxCycle = 0}) async* {
    int i = 0;
    while (!_loadedTeams) {
      yield i++;
      await Future.delayed(Duration(milliseconds: intervalMillisecond));
      print('loaderDB: $_loadedTeams');

      if (maxCycle != 0 && maxCycle == i) break;
    }
    print('loader DB done');
  }

  Future<void> _loadTeams() async {
    if (_db == null) {
      await init();
    }
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);
    final teamsSnapshot = await _storeTeams.find(_db, finder: finder);
    List<Team> teamList = [];
    for (RecordSnapshot teamRecord in teamsSnapshot) {
      teamList.add(Team.fromMap(teamRecord.key, teamRecord.value));
    }
    for (Team team in teamList) {
      await loadAllPokemonFromTeam(team)
          .then((pokemonListOfTeam) => team.teamPokemon = pokemonListOfTeam);
    }
    _pokemonTeamsLoadedFromDB = teamList;
  }

  Future<List<PokemonInstance>> loadAllPokemonFromTeam(Team team) async {
    if (_db == null) {
      await init();
    }
    final finder = Finder(filter: Filter.equals('teamDbKey', team.dbKey));
    final pokemonSnapshot = await _storePokemon.find(_db, finder: finder);
    List<PokemonInstance> pokemonList = [];
    for (RecordSnapshot pokemonRecord in pokemonSnapshot) {
      pokemonList.add(PokemonInstance.fromMap(
          pokemonRecord.key, pokemonRecord.value, team));
    }
    return pokemonList;
  }

  //store a team without pokemon members
  Future<int> storeNewTeam(Team team) async {
    if (_db == null) {
      await init();
    }
    int id = await _storeTeams.add(_db, team.map);
    team.dbKey = id;
    return id;
  }

  //store a team without pokemon members
  Future<int> storeItem(PokemonItem pokemonItem) async {
    if (_db == null) {
      await init();
    }
    int id = await _storeItems.add(_db, pokemonItem.map);
    return id;
  }

  Future<List<PokemonItem>> loadItems() async {
    if (_db == null) {
      await init();
    }
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);
    final itemsSnapshot = await _storeItems.find(_db, finder: finder);
    List<PokemonItem> itemList = [];
    for (RecordSnapshot itemRecord in itemsSnapshot) {
      itemList.add(PokemonItem.fromMap(itemRecord.value));
    }
    return itemList;
  }

  Future<int> storePokemonInstanceInTeam(PokemonInstance pokemon) async {
    if (_db == null) {
      await init();
    }
    int id = await _storePokemon.add(_db, pokemon.map);
    return id;
  }

  Future<void> deletePokemonInTeam(Pokemon pokemon) async {
    final finder = Finder(filter: Filter.byKey(pokemon.dbKey));
    await _storePokemon.delete(_db, finder: finder);
  }

  Future<void> deleteTeam(Team team) async {
    _deletePokemonFromTeamDbKey(team.dbKey);
    final teamFinder = Finder(filter: Filter.byKey(team.dbKey));
    await _storeTeams.delete(_db, finder: teamFinder);
  }

  Future<void> _deletePokemonFromTeamDbKey(int teamDbKey) async {
    final pokemonFinder = Finder(filter: Filter.equals('teamDbKey', teamDbKey));
    await _storePokemon.delete(_db, finder: pokemonFinder);
  }

  Future renameTeam(Team team) async {
    await _storeTeams.record(team.dbKey).put(_db, team.map);
  }

  Future updatePokemonInstance(PokemonInstance pokemonInstance) async {
    await _storePokemon
        .record(pokemonInstance.dbKey)
        .put(_db, pokemonInstance.map);
  }

  Future resetDb() async {
    if (_db == null) {
      await init();
    }
    await _storeTeams.delete(_db);
    await _storePokemon.delete(_db);
  }

  Future resetPokemon() async {
    if (_db == null) {
      await init();
    }
    await _storePokemon.delete(_db);
  }

  Future resetTeams() async {
    if (_db == null) {
      await init();
    }
    await _storeTeams.delete(_db);
  }

//TODO update quando i pokemon saranno parametrizzati...
}
