import 'package:poke_team/model/pokemon.dart';

//TODO: usare i provider o comunque non usare una Singleton! singleton da usare sui service piuttosto!

class Team{

  static final Team _instance = Team._privateConstructor();
  List <Pokemon> teamMembers = [  ];

  //costruttore privato
  Team._privateConstructor();

  factory Team(){
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