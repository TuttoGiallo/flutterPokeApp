import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

class AddAPokemonDialog extends StatelessWidget {
  const AddAPokemonDialog(
      {Key key, @required this.allPokemonName, @required this.onAddedPokemon})
      : super(key: key);
  final List<String> allPokemonName;
  final Function(String pokemonName) onAddedPokemon;

  @override
  Widget build(BuildContext context) {
    String pokemonName = '';
    return AlertDialog(
      title: const Text('Add Pokemon in Team:'),
      content: SizedBox(
        width: 250,
        child:
            //definizione di un widget (del suo nome) nel momento stesso in cui vieni definito nel return.
            AutoCompleteTextField<String>(
                //TODO cambiare da string name a oggetto pair name/id
                clearOnSubmit: false,
                key: key,
                decoration: const InputDecoration(
                    helperText: "Enter Pokemon name or IDß"),
                suggestions: allPokemonName,
                itemBuilder: (context, pokemonName) {
                  return Container(
                    color: Colors.grey[800],
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        pokemonName,
                        style: TextStyle(fontSize: 20, color: Colors.grey[300]),
                      ),
                    ),
                  ); //TODO: presentare il nome e l'id nella ricerca
                },
                itemFilter: (pokemonName, inputText) {
                  //TODO: cambiare in coppia name,id. ricorda
                  return pokemonName.contains(inputText);
                },
                itemSorter: (pokemonName1, pokemonName2) {
                  return pokemonName1.compareTo(pokemonName2);
                },
                itemSubmitted: (pn) {
                  pokemonName = pn;
                },
                style: TextStyle(
                  fontSize: 28.0,
                  color: Colors.grey[800],
                  fontStyle: FontStyle.italic,
                )),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            print('addPokemonDialog press');
            await onAddedPokemon(pokemonName);
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
