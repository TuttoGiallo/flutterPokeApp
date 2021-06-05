import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

class AddAPokemonDialog extends StatelessWidget {
  const AddAPokemonDialog(
      {Key key, @required this.allPokemonName})
      : super(key: key);
  final List<String> allPokemonName;

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = new TextEditingController();
    return AlertDialog(
      title: const Text('Add Pokemon in Team:'),
      content: SizedBox(
        width: 250,
        child:
            //definizione di un widget (del suo nome) nel momento stesso in cui vieni definito nel return.
            AutoCompleteTextField<String>(
              controller: textController,
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
                  textController.text = pn;
                },
                style: TextStyle(
                  fontSize: 28.0,
                  color: Colors.grey[800],
                  fontStyle: FontStyle.italic,
                )),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, {'ok': false}),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context, {'ok': true, 'pokemonName': textController.text});
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
