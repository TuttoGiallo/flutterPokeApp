import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemon.dart';
import 'package:poke_team/model/pokemonInstance.dart';
import 'package:poke_team/widgets/pokeBaseStatsCard.dart';
import 'package:poke_team/widgets/pokeInfoCard.dart';
import 'package:poke_team/widgets/pokeTypesEffectCard.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  Function onAddButtonPress = (context, PokemonInstance pokemon) =>  Navigator.pop(context, pokemon);

  @override
  Widget build(BuildContext context) {
    //retrieve the object pass from loading page.
    Map pushedArgs = ModalRoute.of(context).settings.arguments;
    poke = pushedArgs['pokemon'];

    List<Widget> _widgetOptions = <Widget>[
      //getPokeInfo(addButtonVisibility),
      PokeInfoCard(addButtonVisibility: pushedArgs['add'],
          pokemon: this.poke, onAddButtonPressed: onAddButtonPress),
      PokeTypesEffectCard(poke: this.poke),
      PokeBaseStatsCard(poke: this.poke),
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