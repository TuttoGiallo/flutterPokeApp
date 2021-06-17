import 'dart:convert';

import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/model/pokemonStats.dart';

class Team {
  String name;
  int dbKey;

  List<PokemonInstance> teamMembers = [];

  Team(this.name);

  Team.fromMap(this.dbKey, Map<String, dynamic> teamMap) {
    name = teamMap['name'];
  }

  Map<String, dynamic> get map {
    return {
      'name': name,
    };
  }

  Map<String, dynamic> get mapTeamAndMember {
    List<Map<String, dynamic>> members = [];
    this.teamMembers.forEach((pokemon) => members.add(pokemon.toJson()));
    return {
      'team': map,
      'members': members,
    };
  }

  Map toJson() => this.mapTeamAndMember;

  set teamPokemon(List<PokemonInstance> teamPokemon) {
    this.teamMembers = teamPokemon;
  }

  void addPokemon(PokemonInstance pokemon) {
    this.teamMembers.add(pokemon);
  }

  void removePokemon(PokemonInstance pokemon) {
    this.teamMembers.remove(pokemon);
  }

  bool isTeamFull() {
    return teamMembers.length >= 6;
  }

  bool isTeamNotFull() {
    return teamMembers.length < 6;
  }

  bool isTeamEmpty() {
    return teamMembers.length == 0;
  }

  bool isTeamNotEmpty() {
    return teamMembers.length > 0;
  }

  static List<PokemonInstance> getANewListOfMemberSortedByStat(List<PokemonInstance> pokemonList, StatName statName,
      {abilityCheck = false, itemCheck = false, desc = false}) {
    List<PokemonInstance> sortedMemberList = [];
    sortedMemberList.addAll(pokemonList);
    if (desc)
      sortedMemberList.sort((p1, p2) =>
          p1.getStatFromNameStat(statName,
              abilityCheck: abilityCheck, itemCheck: itemCheck) -
          p2.getStatFromNameStat(statName,
              abilityCheck: abilityCheck, itemCheck: itemCheck));
    else
      sortedMemberList.sort((p1, p2) =>
          p2.getStatFromNameStat(statName,
              abilityCheck: abilityCheck, itemCheck: itemCheck) -
          p1.getStatFromNameStat(statName,
              abilityCheck: abilityCheck, itemCheck: itemCheck));
    return sortedMemberList;
  }
}
