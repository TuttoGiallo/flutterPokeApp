import 'package:poke_team/model/pokemon.dart';

//TODO: usare i provider o comunque non usare una Singleton! singleton da usare sui service piuttosto!

@deprecated
class TeamV1{

  static final TeamV1 _instance = TeamV1._privateConstructor();
  List <Pokemon> teamMembers = [  ];

  //costruttore privato
  TeamV1._privateConstructor();

  factory TeamV1(){
    return _instance;
  }

  void addPokemon(Pokemon pokemon){
    this.teamMembers.add(pokemon);
  }

  void removePokemon(Pokemon pokemon){
    this.teamMembers.remove(pokemon);
  }

  bool isTeamFull(){
    return teamMembers.length >= 6;
  }

  bool isTeamEmpty(){
    return teamMembers.length == 0;
  }
}