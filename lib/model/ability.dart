class Ability{
  String name;
  String shortEffect;
  String effect;

  bool hidden;
  int slot;

  Ability(this.name, {this.hidden, this.slot, this.shortEffect, this.effect});
}