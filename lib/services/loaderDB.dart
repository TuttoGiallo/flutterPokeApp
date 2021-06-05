import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/model/team.dart';
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
      await loadAllPokemonFromTeam(team)
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

  Future<void> deletePokemonInTeam(Pokemon pokemon) async {
    final finder = Finder(filter: Filter.byKey(pokemon.dbKey));
    await storePokemon.delete(_db, finder: finder);
  }

  Future<void> deleteTeam(Team team) async {
    deletePokemonFromTeamDbKey(team.dbKey);
    final teamFinder = Finder(filter: Filter.byKey(team.dbKey));
    await storeTeams.delete(_db, finder: teamFinder);
  }

  Future<void> deletePokemonFromTeamDbKey(int teamDbKey) async {
    final pokemonFinder = Finder(filter: Filter.equals('teamDbKey', teamDbKey));
    await storePokemon.delete(_db, finder: pokemonFinder);
  }

  Future resetDb() async {
    if (_db == null) {
      await init();
    }
    await storeTeams.delete(_db);
    await storePokemon.delete(_db);
  }

  Future resetPokemon() async {
    if (_db == null) {
      await init();
    }
    await storePokemon.delete(_db);
  }

  Future resetTeams() async {
    if (_db == null) {
      await init();
    }
    await storeTeams.delete(_db);
  }

//TODO update quando i pokemon saranno parametrizzati...
}
