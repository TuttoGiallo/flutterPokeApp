import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/model/pokemonType.dart';
import 'package:poke_team/model/wrinDamage.dart';

class PokemonTypes {
  //Singleton per il mantenimento dei dati e della logica sui tipi.
  static final PokemonTypes _instance = PokemonTypes._privateConstructor();

  PokemonTypes._privateConstructor() {
    populateWeakness();
    populateImmunity();
    populateResistance();
    return;
  }

  factory PokemonTypes() {
    return _instance;
  }

  static final PokemonType normal = PokemonType('normal');
  static final PokemonType grass = new PokemonType('grass');
  static final PokemonType poison = new PokemonType('poison');
  static final PokemonType electric = new PokemonType('electric');
  static final PokemonType water = new PokemonType('water');
  static final PokemonType fairy = new PokemonType('fairy');
  static final PokemonType fire = new PokemonType('fire');
  static final PokemonType flying = new PokemonType('flying');
  static final PokemonType rock = new PokemonType('rock');
  static final PokemonType ground = new PokemonType('ground');
  static final PokemonType bug = new PokemonType('bug');
  static final PokemonType dragon = new PokemonType('dragon');
  static final PokemonType psychic = new PokemonType('psychic');
  static final PokemonType dark = new PokemonType('dark');
  static final PokemonType ghost = new PokemonType('ghost');
  static final PokemonType fighting = new PokemonType('fighting');
  static final PokemonType ice = new PokemonType('ice');
  static final PokemonType steel = new PokemonType('steel');

  //TODO: rendere la mappa privata
  static final Map<String, PokemonType> _typesNameMap = {
    'normal': normal,
    'grass': grass,
    'poison': poison,
    'electric': electric,
    'water': water,
    'fairy': fairy,
    'fire': fire,
    'flying': flying,
    'rock': rock,
    'ground': ground,
    'bug': bug,
    'dragon': dragon,
    'psychic': psychic,
    'dark': dark,
    'ghost': ghost,
    'fighting': fighting,
    'ice': ice,
    'steel': steel,
  };

  List<PokemonType> getAllTypes() {
    return [
      normal,
      grass,
      poison,
      electric,
      water,
      fairy,
      fire,
      flying,
      rock,
      ground,
      bug,
      dragon,
      psychic,
      dark,
      ghost,
      fighting,
      ice,
      steel
    ];
  }

  PokemonType getTypeFromName(String name) {
    return _typesNameMap[name];
  }

  void populateWeakness() {
    normal.weakness.add(fighting);
    fighting.weakness.addAll([flying, psychic, fairy]);
    flying.weakness.addAll([rock, electric, ice]);
    poison.weakness.addAll([ground, psychic]);
    ground.weakness.addAll([water, grass, ice]);
    rock.weakness.addAll([fighting, ground, steel, water, grass]);
    bug.weakness.addAll([fire, flying, rock]);
    ghost.weakness.addAll([ghost, dark]);
    steel.weakness.addAll([fighting, ground, fire]);
    fire.weakness.addAll([water, rock, ground]);
    water.weakness.addAll([grass, electric]);
    grass.weakness.addAll([flying, ice, fire, poison, bug]);
    electric.weakness.addAll([ground]);
    psychic.weakness.addAll([bug, ghost, dark]);
    ice.weakness.addAll([fire, fighting, rock, steel]);
    dragon.weakness.addAll([dragon, ice, fairy]);
    dark.weakness.addAll([fighting, bug, fairy]);
    fairy.weakness.addAll([steel, poison]);
  }

  void populateResistance() {
    fighting.resistance.addAll([rock, bug, dark]);
    flying.resistance.addAll([grass, fighting, bug]);
    poison.resistance.addAll([fighting, poison, bug, grass, fairy]);
    ground.resistance.addAll([poison, rock]);
    rock.resistance.addAll([normal, flying, poison, fire]);
    bug.resistance.addAll([grass, fighting, ground]);
    ghost.resistance.addAll([poison, bug]);
    steel.resistance.addAll([
      normal,
      flying,
      poison,
      rock,
      bug,
      steel,
      grass,
      psychic,
      ice,
      dragon,
      fairy
    ]);
    fire.resistance.addAll([fire, fairy, bug, grass, steel, ice]);
    water.resistance.addAll([steel, ice, fire, water]);
    grass.resistance.addAll([grass, water, ground, electric]);
    electric.resistance.addAll([flying, steel, electric]);
    psychic.resistance.addAll([fighting, psychic]);
    ice.resistance.add(ice);
    dragon.resistance.addAll([grass, water, fire, electric]);
    dark.resistance.addAll([ghost, dark]);
    fairy.resistance.addAll([dark, fighting, bug]);
  }

  void populateImmunity() {
    normal.immunity.add(ghost);
    flying.immunity.add(ground);
    ground.immunity.add(electric);
    ghost.immunity.addAll([normal, fighting]);
    dark.immunity.add(psychic);
    fairy.immunity.add(dragon);
  }

  //creazione della mappa<tipo-fattore> del danno ricevuto da un Pokemon
  Map<PokemonType, double> getTypeEffectsPokemon(Pokemon pokemon) {
    Map<PokemonType, double> pokemonTypeEffect = {};
    getAllTypes().forEach((type) {
      pokemonTypeEffect[type] = 1;
    });
    pokemon.type1.weakness.forEach((weakness) {
      pokemonTypeEffect[weakness] *= 2;
    });
    pokemon.type1.resistance.forEach((resistance) {
      pokemonTypeEffect[resistance] *= 1 / 2;
    });
    pokemon.type1.immunity.forEach((immunity) {
      pokemonTypeEffect[immunity] *= 0;
    });

    if (pokemon.type2 != null) {
      pokemon.type2.weakness.forEach((weakness) {
        pokemonTypeEffect[weakness] *= 2;
      });
      pokemon.type2.resistance.forEach((resistance) {
        pokemonTypeEffect[resistance] *= 1 / 2;
      });
      pokemon.type2.immunity.forEach((immunity) {
        pokemonTypeEffect[immunity] *= 0;
      });
    }
    return pokemonTypeEffect;
  }

  //creazione della mappa<tipo-fattore> delle debolezze di un Pokemon
  Map<PokemonType, double> getTypeWeaknessPokemon(Pokemon pokemon) {
    return getFilteredSortedTypePokemonEffect(pokemon, WeaknessResistanceImmunityNormalDamage.weakness);
  }

  //creazione della mappa<tipo-fattore> del resistenze di un Pokemon
  Map<PokemonType, double> getTypeResistencePokemon(Pokemon pokemon) {
    return getFilteredSortedTypePokemonEffect(pokemon, WeaknessResistanceImmunityNormalDamage.resistance);
  }

  //creazione della mappa<tipo-fattore> del immunità di un Pokemon
  Map<PokemonType, double> getTypeImmunityPokemon(Pokemon pokemon) {
    return getFilteredSortedTypePokemonEffect(pokemon, WeaknessResistanceImmunityNormalDamage.immunity);
  }

  //creazione della mappa<tipo-fattore> del danno normale di un Pokemon
  Map<PokemonType, double> getTypeNormalDamagePokemon(Pokemon pokemon) {
    return getFilteredSortedTypePokemonEffect(pokemon, WeaknessResistanceImmunityNormalDamage.normal);
  }

  //creazione della mappa<tipo-fattore> gli effetti di un Pokemon
  Map<PokemonType, double> getFilteredSortedTypePokemonEffect(Pokemon pokemon, WeaknessResistanceImmunityNormalDamage wrind) {
    Map<PokemonType, double> typeEffectsPokemon =
    getTypeEffectsPokemon(pokemon);
    List<MapEntry<PokemonType, double>> pokemonSortTypesEffect = [];
    getAllTypes().forEach((type) {
      double factor = typeEffectsPokemon[type];
      if (factor > 1 && wrind==WeaknessResistanceImmunityNormalDamage.weakness ||
          0 < factor && factor < 1  && wrind==WeaknessResistanceImmunityNormalDamage.resistance ||
          factor == 0 && wrind==WeaknessResistanceImmunityNormalDamage.immunity ||
          factor == 1 && wrind==WeaknessResistanceImmunityNormalDamage.normal)
        pokemonSortTypesEffect.add(MapEntry(type, typeEffectsPokemon[type]));
    });
    pokemonSortTypesEffect.sort((a,  b) => (b.value*10 - a.value*10).toInt());
    return Map.fromIterable(pokemonSortTypesEffect,
        key: (entryList) => entryList.key,
        value: (entryValue) => entryValue.value);
  }//vabbeh, mega bordello per ritornare una mappa ordinata...


}
