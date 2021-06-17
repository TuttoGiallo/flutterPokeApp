import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/model/pokemonStats.dart';

class PokemonItem {
  String name;
  String description;

  ItemCategory itemCategory;

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

  static int itemStatAlter(PokemonItem item, StatName statName, int statValue) {
    //TODO finire implementazione
    if (item == null) return statValue;

    double toRoundReturnValue = statValue * 1.0;
    switch (item.name) {
      case 'choice-band':
        if (statName == StatName.attack) toRoundReturnValue *= 1.5;
        break;
      case 'choice-scarf':
        if (statName == StatName.speed) toRoundReturnValue *= 1.5;
        break;
      case 'choice-specs':
        if (statName == StatName.specialAttack) toRoundReturnValue *= 1.5;
        break;
      case 'life-orb':
        if (statName == StatName.specialAttack) toRoundReturnValue *= 1.3;
        if (statName == StatName.attack) toRoundReturnValue *= 1.3;
        break;
      case 'assault-vest':
        if (statName == StatName.specialAttack) toRoundReturnValue *= 1.3;
        if (statName == StatName.attack) toRoundReturnValue *= 1.3;
        break;
      case 'eviolite':
        if (statName == StatName.defense) toRoundReturnValue *= 1.5;
        if (statName == StatName.specialDefense) toRoundReturnValue *= 1.5;
        break;
    }
    return toRoundReturnValue.round();
  }

  static PokemonItem getMegaStoneFor(Pokemon pokemon, List<PokemonItem> items) {
    return items.firstWhere((item) =>
        item.itemCategory == ItemCategory.megaStones &&
        item.description.toUpperCase().contains(pokemon.name.split('-').first.toUpperCase()));
  }
}

enum ItemCategory {
  choice,
  heldItems,
  megaStones,
}
