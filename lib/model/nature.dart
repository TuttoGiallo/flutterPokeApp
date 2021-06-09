import 'package:poke_team/model/pokemon.dart';

class Nature {
  NatureName name;

  BaseStatName up;
  BaseStatName down;

  Nature(this.name) {
    switch (this.name) {
      case NatureName.Hardy:
        up = BaseStatName.attack;
        down = BaseStatName.attack;
        break;
      case NatureName.Lonely:
        up = BaseStatName.attack;
        down = BaseStatName.defense;
        break;
      case NatureName.Brave:
        up = BaseStatName.attack;
        down = BaseStatName.speed;
        break;
      case NatureName.Adamant:
        up = BaseStatName.attack;
        down = BaseStatName.specialAttack;
        break;
      case NatureName.Naughty:
        up = BaseStatName.attack;
        down = BaseStatName.specialDefence;
        break;

      case NatureName.Bold:
        up = BaseStatName.defense;
        down = BaseStatName.attack;
        break;
      case NatureName.Docile:
        up = BaseStatName.defense;
        down = BaseStatName.defense;
        break;
      case NatureName.Relaxed:
        up = BaseStatName.defense;
        down = BaseStatName.speed;
        break;
      case NatureName.Impish:
        up = BaseStatName.defense;
        down = BaseStatName.specialAttack;
        break;
      case NatureName.Lax:
        up = BaseStatName.defense;
        down = BaseStatName.specialDefence;
        break;

      case NatureName.Timid:
        up = BaseStatName.speed;
        down = BaseStatName.attack;
        break;
      case NatureName.Hasty:
        up = BaseStatName.speed;
        down = BaseStatName.defense;
        break;
      case NatureName.Serious:
        up = BaseStatName.speed;
        down = BaseStatName.speed;
        break;
      case NatureName.Jolly:
        up = BaseStatName.speed;
        down = BaseStatName.specialAttack;
        break;
      case NatureName.Naive:
        up = BaseStatName.speed;
        down = BaseStatName.specialDefence;
        break;

      case NatureName.Modest:
        up = BaseStatName.specialAttack;
        down = BaseStatName.attack;
        break;
      case NatureName.Mild:
        up = BaseStatName.specialAttack;
        down = BaseStatName.defense;
        break;
      case NatureName.Quiet:
        up = BaseStatName.specialAttack;
        down = BaseStatName.speed;
        break;
      case NatureName.Bashful:
        up = BaseStatName.specialAttack;
        down = BaseStatName.specialAttack;
        break;
      case NatureName.Rash:
        up = BaseStatName.specialAttack;
        down = BaseStatName.specialDefence;
        break;

      case NatureName.Calm:
        up = BaseStatName.specialDefence;
        down = BaseStatName.attack;
        break;
      case NatureName.Gentle:
        up = BaseStatName.specialDefence;
        down = BaseStatName.defense;
        break;
      case NatureName.Sassy:
        up = BaseStatName.specialDefence;
        down = BaseStatName.speed;
        break;
      case NatureName.Careful:
        up = BaseStatName.specialDefence;
        down = BaseStatName.specialAttack;
        break;
      case NatureName.Quirky:
        up = BaseStatName.specialDefence;
        down = BaseStatName.specialDefence;
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
