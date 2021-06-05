import 'dart:convert';
import 'package:http/http.dart';
import 'package:poke_team/model/ability.dart';
import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/model/pokemonTypes.dart';

class PokeApi {
  String urlBase = 'https://pokeapi.co/api/v2/pokemon/';

  Future<Pokemon> loadByName(String name) async {
    Pokemon poke;

    var url = Uri.parse(urlBase + name);
    var response = await get(url);

    Map pokeResp = jsonDecode(response.body);

    poke = new Pokemon(name: pokeResp["name"], id: pokeResp["id"]);

    bool firstType = true;
    for (dynamic type in pokeResp["types"]) {
      if (firstType) {
        poke.type1 = PokemonTypes().getTypeFromName(type["type"]['name']);
        firstType = false;
      } else {
        poke.type2 = PokemonTypes().getTypeFromName(type["type"]['name']);
      }
    }

    for (dynamic baseStat in pokeResp["stats"]) {
      int bs = baseStat["base_stat"];
      switch (baseStat["stat"]['name']) {
        case 'attack':
          poke.baseStats[BaseStatName.attack] = bs;
          break;
        case 'defense':
          poke.baseStats[BaseStatName.defense] = bs;
          break;
        case 'special-attack':
          poke.baseStats[BaseStatName.specialAttack] = bs;
          break;
        case 'special-defense':
          poke.baseStats[BaseStatName.specialDefence] = bs;
          break;
        case 'hp':
          poke.baseStats[BaseStatName.hp] = bs;
          break;
        case 'speed':
          poke.baseStats[BaseStatName.speed] = bs;
          break;
      }
    }

    poke.urlSprite = pokeResp['sprites']['front_default'];

    for (dynamic ability in pokeResp['abilities']) {

      var urlAbilityDetails = Uri.parse(ability['ability']['url']);
      var responseAbilityDetails = await get(urlAbilityDetails);
      Map abilityResp = jsonDecode(responseAbilityDetails
          .body); //TODO chiamate con singolo client? paralelizzare le chiamate?

      List flavorTextEntry = abilityResp['effect_entries'];
      dynamic effectEntrie =
          flavorTextEntry.where((eE) => eE['language']['name'] == 'en').first;

      poke.abilities.add(new Ability(ability['ability']['name'],
          hidden: ability['is_hidden'],
          shortEffect: effectEntrie['short_effect'],
          effect: effectEntrie['effect']));
    }

    return poke;
  }
}
