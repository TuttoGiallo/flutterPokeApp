enum StatName { hp, attack, defense, specialAttack, specialDefense, speed }

class PokemonStats {
  static String statNameToString(StatName baseStatName) {
    switch (baseStatName) {
      case StatName.hp:
        return "HP";
      case StatName.attack:
        return "Attack";
      case StatName.defense:
        return "Defence";
      case StatName.specialAttack:
        return "Special Attack";
      case StatName.specialDefense:
        return "Special Defense";
      case StatName.speed:
        return "Speed";
    }
    return '';
  }

  static String statNameToAbbreviation(StatName baseStatName) {
    switch (baseStatName) {
      case StatName.hp:
        return "HP";
      case StatName.attack:
        return "Att";
      case StatName.defense:
        return "Def";
      case StatName.specialAttack:
        return "SpA";
      case StatName.specialDefense:
        return "SpD";
      case StatName.speed:
        return "Spe";
    }
    return '';
  }

  static Map<StatName, int> getNewInitializedMapBaseStats({int initValue = 0}) {
    return {
      StatName.hp: initValue,
      StatName.attack: initValue,
      StatName.defense: initValue,
      StatName.specialAttack: initValue,
      StatName.specialDefense: initValue,
      StatName.speed: initValue
    };
  }

  static List<StatName> statNamesIterable() {
    return [
      StatName.hp,
      StatName.attack,
      StatName.defense,
      StatName.specialAttack,
      StatName.specialDefense,
      StatName.speed,
    ];
  }
}
