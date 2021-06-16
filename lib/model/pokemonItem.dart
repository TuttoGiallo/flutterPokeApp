import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/model/pokemonStats.dart';

class PokemonItem {
  String name;
  String description;

  ItemCategory itemCategory;

  ///ritorna il fattore di modifica di una singola stat dato da un oggetto
  ///es: choice-band(atk) -> 1.5, choice-band(def) -> 1
  ///pokemon Instance è usato per determinare se ci sono determinate condizioni come: evioliote o assault vest
  Function(StatName stat, PokemonInstance pokemonInstance) effectOnStats;

  PokemonItem(this.name, this.description, this.itemCategory);

  PokemonItem.fromMap(Map<String, dynamic> pokemonMap) {
    name = pokemonMap['name'];
    description = pokemonMap['description'];
    itemCategory = getItemCategoryFromString(pokemonMap['itemCategory']);
  }

  Map<String, dynamic> get map {
    return {
      'description': description,
      'name': name,
      'itemCategory': getStringFromItemCategory(itemCategory),
    };
  }

  static ItemCategory getItemCategoryFromString(String categoryString) {
    switch (categoryString) {
      case 'choice':
        return ItemCategory.choice;
      case 'held-items':
        return ItemCategory.heldItems;
      case 'mega-stones':
        return ItemCategory.megaStones;
    }
    return null;
  }

  static String getStringFromItemCategory(ItemCategory category) {
    switch (category) {
      case ItemCategory.choice:
        return 'choice';
      case ItemCategory.heldItems:
        return 'held-items';
      case ItemCategory.megaStones:
        return 'mega-stones';
    }
    return '';
  }

  Map toJson() => this.map;


  static  void loadEffectsOfItem(PokemonItem item) {
      //TODO finire implementazione
      switch (item.name) {
        case 'choice-band':
          item.effectOnStats =
              (StatName stat, PokemonInstance pokemonInstance) => stat == StatName.attack ? 1.5 : 1;
          break;
        case 'choice-scarf':
          item.effectOnStats =
              (StatName stat, PokemonInstance pokemonInstance) => stat == StatName.speed ? 1.5 : 1;
          break;
        case 'choice-specs':
          item.effectOnStats =
              (StatName stat, PokemonInstance pokemonInstance) => stat == StatName.specialAttack ? 1.5 : 1;
          break;
    }
  }



}

enum ItemCategory {
  choice,
  heldItems,
  megaStones,
}
