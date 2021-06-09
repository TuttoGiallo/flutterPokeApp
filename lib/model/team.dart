import 'package:poke_team/model/pokemonInstance.dart';

class Team{
  String name;
  int dbKey;

  List <PokemonInstance> teamMembers = [  ];

  Team(this.name);

  Team.fromMap(this.dbKey, Map<String, dynamic> teamMap) {
    name = teamMap['name'];
  }

  Map<String, dynamic> get map {
    return {
      'name': name,
    };
  }

  set teamPokemon(List<PokemonInstance> teamPokemon){
    this.teamMembers = teamPokemon;
  }

  void addPokemon(PokemonInstance pokemon){
    this.teamMembers.add(pokemon);
  }

  void removePokemon(PokemonInstance pokemon){
    this.teamMembers.remove(pokemon);
  }

  bool isTeamFull(){
    return teamMembers.length >= 6;
  }

  bool isTeamNotFull(){
    return teamMembers.length < 6;
  }

  bool isTeamEmpty(){
    return teamMembers.length == 0;
  }
}