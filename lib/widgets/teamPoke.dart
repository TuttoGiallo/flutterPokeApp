import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poke_team/model/pokemon.dart';


@deprecated
class TeamPoke extends StatefulWidget {
  const TeamPoke({Key key, @required this.poke, @required this.deletePokemonFunctionCallBack}) : super(key: key);

  final Pokemon poke;
  final Function(Pokemon poke) deletePokemonFunctionCallBack;

  @override
  _TeamPokeState createState() => _TeamPokeState();
}

class _TeamPokeState extends State<TeamPoke> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          print("tap: ${widget.poke.name}");
          Navigator.pushNamed(context, '/loading',
              arguments: {'pokeName': widget.poke.name, 'add': 'false'});
        },
        child: Container(
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
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(widget.poke.name,
                            style: TextStyle(
                              fontSize: 28.0,
                              color: Colors.grey[800],
                              fontStyle: FontStyle.italic,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                        child: IconButton(
                            color: Colors.grey[800],
                            icon: Icon(
                              Icons.delete,
                              size: 40,
                            ),
                            onPressed: () async {
                              bool cancelOk = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Eliminazione Pokemon'),
                                  content: const Text(
                                      'Sicuro di voler eliminare il pokemon dal tuo team?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              if (cancelOk) {
                                widget.deletePokemonFunctionCallBack(widget.poke);
                              }
                            }),
                      )
                    ],
                  )),
            )));
  }
}
