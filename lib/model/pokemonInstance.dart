import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/model/team.dart';

class PokemonInstance extends Pokemon {
  String firstName;
  Team team;

  String
  teamName; //TODO verificare se è sufficiente per quertare nel DB, ma credo di si

  PokemonInstance(Pokemon pokemon, Team team, String firstName)
      : super(
      name: pokemon.name,
      id: pokemon.id,
      type1: pokemon.type1,
      type2: pokemon.type2) {
    this.firstName = firstName;
    super.baseStats = pokemon.baseStats;
    super.abilities = pokemon.abilities;
    super.urlSprite = pokemon.urlSprite;
    this.team = team;
  }

  PokemonInstance.fromMap(int dbKey, Map<String, dynamic> pokemonMap, Team team)
      : super.fromMap(dbKey, pokemonMap){
    this.team = team;
    this.firstName = pokemonMap['firstName'];
  }

  Map<String, dynamic> get map {
    Map<String, dynamic> returnMap = super.map;
    returnMap.addAll({'firstName': this.firstName, 'teamDbKey': team.dbKey});
    return returnMap;
  }
}
