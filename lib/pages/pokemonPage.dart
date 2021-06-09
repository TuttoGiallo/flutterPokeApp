import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/services/loaderDB.dart';
import 'package:poke_team/widgets/pokemon-widget/pokeBaseStatsCard.dart';
import 'package:poke_team/widgets/pokemon-widget/pokeInfoCard.dart';
import 'package:poke_team/widgets/pokemon-widget/pokeStatsCard.dart';
import 'package:poke_team/widgets/pokemon-widget/pokeTypesEffectCard.dart';

class PokemonPage extends StatefulWidget {
  @override
  _PokemonPageState createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  Pokemon poke;
  int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
  }

  _onBottomItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Function onAddButtonPress =
      (context, PokemonInstance pokemon) => Navigator.pop(context, pokemon);

  onUpdatePokemonInstance(PokemonInstance pokemonInstance) {
    LoaderDB().updatePokemonInstance(pokemonInstance);
  }

  @override
  Widget build(BuildContext context) {
    //retrieve the object pass from loading page.
    Map pushedArgs = ModalRoute.of(context).settings.arguments;
    poke = pushedArgs['pokemon'];

    Widget statsWidget = pushedArgs['add']
        ? PokeBaseStatsCard(pokemon: this.poke)
        : PokeStatsCard(pokemon: this.poke, onUpdatePokemonValues: onUpdatePokemonInstance,);

    List<Widget> _widgetOptions = <Widget>[
      //getPokeInfo(addButtonVisibility),
      PokeInfoCard(
        editing: !pushedArgs['add'],
        pokemon: this.poke,
        onAddButtonPressed: onAddButtonPress,
        onUpdatePokemonValues: onUpdatePokemonInstance,
      ),
      PokeTypesEffectCard(poke: this.poke),
      statsWidget,
      //WebView(initialUrl: 'https://bulbapedia.bulbagarden.net/wiki/Pikachu_(Pokémon)') TODO webview!
    ];

    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text('${poke.name.toUpperCase()} PokeCard'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amber,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq),
            label: 'Types Effect',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Base Stats',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.web),
          //   label: 'Wiki on Web',
          // ), //TODO webview!
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey[100],
        onTap: _onBottomItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
