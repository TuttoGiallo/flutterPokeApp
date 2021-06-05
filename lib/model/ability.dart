class Ability{
  String name;
  String shortEffect;
  String effect;

  bool hidden;
  int slot;

  Ability(this.name, {this.hidden, this.slot, this.shortEffect, this.effect});

  Ability.fromMap(Map<String, dynamic> abilityMap) { //TODO creare tabella/store separato per le abilità, così da usare solo delle referenze a esse.
    name = abilityMap['name'];
    shortEffect = abilityMap['shortEffect'];
    hidden = abilityMap['hidden'];
    slot = abilityMap['slot'];
    effect = abilityMap['effect'];
  }

  Map<String, dynamic> get map {
    return {
      'name': name,
      'shortEffect': shortEffect,
      'hidden': hidden,
      'slot': slot,
      'effect': effect,
    };
  }

  Map toJson() => this.map;
}