import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/model/pokemonStats.dart';

class Nature {
  NatureName name;

  StatName up;
  StatName down;

  Nature(this.name) {
    switch (this.name) {
      case NatureName.Hardy:
        up = StatName.attack;
        down = StatName.attack;
        break;
      case NatureName.Lonely:
        up = StatName.attack;
        down = StatName.defense;
        break;
      case NatureName.Brave:
        up = StatName.attack;
        down = StatName.speed;
        break;
      case NatureName.Adamant:
        up = StatName.attack;
        down = StatName.specialAttack;
        break;
      case NatureName.Naughty:
        up = StatName.attack;
        down = StatName.specialDefense;
        break;

      case NatureName.Bold:
        up = StatName.defense;
        down = StatName.attack;
        break;
      case NatureName.Docile:
        up = StatName.defense;
        down = StatName.defense;
        break;
      case NatureName.Relaxed:
        up = StatName.defense;
        down = StatName.speed;
        break;
      case NatureName.Impish:
        up = StatName.defense;
        down = StatName.specialAttack;
        break;
      case NatureName.Lax:
        up = StatName.defense;
        down = StatName.specialDefense;
        break;

      case NatureName.Timid:
        up = StatName.speed;
        down = StatName.attack;
        break;
      case NatureName.Hasty:
        up = StatName.speed;
        down = StatName.defense;
        break;
      case NatureName.Serious:
        up = StatName.speed;
        down = StatName.speed;
        break;
      case NatureName.Jolly:
        up = StatName.speed;
        down = StatName.specialAttack;
        break;
      case NatureName.Naive:
        up = StatName.speed;
        down = StatName.specialDefense;
        break;

      case NatureName.Modest:
        up = StatName.specialAttack;
        down = StatName.attack;
        break;
      case NatureName.Mild:
        up = StatName.specialAttack;
        down = StatName.defense;
        break;
      case NatureName.Quiet:
        up = StatName.specialAttack;
        down = StatName.speed;
        break;
      case NatureName.Bashful:
        up = StatName.specialAttack;
        down = StatName.specialAttack;
        break;
      case NatureName.Rash:
        up = StatName.specialAttack;
        down = StatName.specialDefense;
        break;

      case NatureName.Calm:
        up = StatName.specialDefense;
        down = StatName.attack;
        break;
      case NatureName.Gentle:
        up = StatName.specialDefense;
        down = StatName.defense;
        break;
      case NatureName.Sassy:
        up = StatName.specialDefense;
        down = StatName.speed;
        break;
      case NatureName.Careful:
        up = StatName.specialDefense;
        down = StatName.specialAttack;
        break;
      case NatureName.Quirky:
        up = StatName.specialDefense;
        down = StatName.specialDefense;
        break;
    }
  }

  String getNatureNameToString() {
    switch (this.name) {
      case NatureName.Hardy:
        return "Hardy";
      case NatureName.Lonely:
        return "Lonely";
      case NatureName.Brave:
        return "Brave";
      case NatureName.Adamant:
        return "Adamant";
      case NatureName.Naughty:
        return "Naughty";
      case NatureName.Bold:
        return "Bold";
      case NatureName.Docile:
        return "Docile";
      case NatureName.Relaxed:
        return "Relaxed";
      case NatureName.Impish:
        return "Impish";
      case NatureName.Lax:
        return "Lax";
      case NatureName.Timid:
        return "Timid";
      case NatureName.Hasty:
        return "Hasty";
      case NatureName.Serious:
        return "Serious";
      case NatureName.Jolly:
        return "Jolly";
      case NatureName.Naive:
        return "Naive";
      case NatureName.Modest:
        return "Modest";
      case NatureName.Mild:
        return "Mild";
      case NatureName.Quiet:
        return "Quiet";
      case NatureName.Bashful:
        return "Bashful";
      case NatureName.Rash:
        return "Rash";
      case NatureName.Calm:
        return "Calm";
      case NatureName.Gentle:
        return "Gentle";
      case NatureName.Sassy:
        return "Sassy";
      case NatureName.Careful:
        return "Careful";
      case NatureName.Quirky:
        return "Quirky";
    }
    return '';
  }

  static List<Nature> getAllNatures(){
    return [
      new Nature(NatureName.Hardy),
      new Nature(NatureName.Lonely),
      new Nature(NatureName.Brave),
      new Nature(NatureName.Adamant),
      new Nature(NatureName.Naughty),
      new Nature(NatureName.Bold),
      new Nature(NatureName.Docile),
      new Nature(NatureName.Relaxed),
      new Nature(NatureName.Impish),
      new Nature(NatureName.Lax),
      new Nature(NatureName.Timid),
      new Nature(NatureName.Hasty),
      new Nature(NatureName.Serious),
      new Nature(NatureName.Jolly),
      new Nature(NatureName.Naive),
      new Nature(NatureName.Modest),
      new Nature(NatureName.Mild),
      new Nature(NatureName.Quiet),
      new Nature(NatureName.Bashful),
      new Nature(NatureName.Rash),
      new Nature(NatureName.Calm),
      new Nature(NatureName.Gentle),
      new Nature(NatureName.Sassy),
      new Nature(NatureName.Careful),
      new Nature(NatureName.Quirky),
    ];


  }


}

enum NatureName {
  Hardy,
  Lonely,
  Brave,
  Adamant,
  Naughty,
  Bold,
  Docile,
  Relaxed,
  Impish,
  Lax,
  Timid,
  Hasty,
  Serious,
  Jolly,
  Naive,
  Modest,
  Mild,
  Quiet,
  Bashful,
  Rash,
  Calm,
  Gentle,
  Sassy,
  Careful,
  Quirky
}
