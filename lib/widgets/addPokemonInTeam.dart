import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPokemonInTeam extends StatefulWidget {
  const AddPokemonInTeam(
      {Key key,
      @required this.allPokemonName,
      @required this.onAddPokemonConfirm})
      : super(key: key);

  final List<String> allPokemonName;
  final Function(String pokemoNameOrId) onAddPokemonConfirm;

  @override
  _AddPokemonInTeamState createState() => _AddPokemonInTeamState();
}

class _AddPokemonInTeamState extends State<AddPokemonInTeam> {
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  AutoCompleteTextField searchTextField;

  String pokemonName = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[400],
            border: Border.all(
              color: Colors.amber,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 10.0),
                child: SizedBox(
                  width: 250,
                  //TODO: size fissa mi sembra una minchiata
                  child:
                      //definizione di un widget (del suo nome) nel momento stesso in cui vieni definito nel return.
                      searchTextField = AutoCompleteTextField<String>(
                          //TODO cambiare da string name a oggetto pair name/id
                          clearOnSubmit: false,
                          key: key,
                          decoration: const InputDecoration(
                              helperText: "Enter Pokemon name"),
                          suggestions: widget.allPokemonName,
                          itemBuilder: (context, pokemonName) {
                            return Container(
                              color: Colors.grey[800],
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                    pokemonName
                                ,style: TextStyle(fontSize: 20, color: Colors.grey[300]),),
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
                          itemSubmitted: (pokemonName) {
                            setState(() {
                              this.pokemonName = pokemonName;
                            });
                          },
                          style: TextStyle(
                            fontSize: 28.0,
                            color: Colors.grey[800],
                            fontStyle: FontStyle.italic,
                          )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 14.0, 0.0),
                child: FloatingActionButton(
                  backgroundColor: Colors.amber,
                  splashColor: Colors.yellowAccent,
                  onPressed: () {
                    widget.onAddPokemonConfirm(
                      searchTextField.textField.controller.text);
                    searchTextField.clear();},
                  child: Icon(
                    Icons.add,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
