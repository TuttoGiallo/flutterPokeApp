import 'package:flutter/material.dart';
import 'package:poke_team/services/pokeCustomTheme.dart';

class ImportTeam extends StatelessWidget {
  const ImportTeam({Key key, @required this.onImportTeam}) : super(key: key);

  final Function(String jsonTeam) onImportTeam;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = new TextEditingController();
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Import Team:', style: PokeCustomTheme.getFieldStyle()),
                IconButton(
                  highlightColor: Colors.redAccent,
                  color: Colors.amber,
                  icon: Icon(Icons.cleaning_services_rounded),
                  onPressed: () => controller.clear(),
                )
              ],
            ),
            SizedBox(height: 10),
            Card(
              color: Colors.grey,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  maxLines: 20,
                  decoration: InputDecoration.collapsed(
                      hintText: "Enter your text here"),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: PokeCustomTheme.getFieldStyle(),
                primary: Colors.amber,
              ),
              onPressed: () => onImportTeam(controller.text),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.download_outlined),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('IMPORT'),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
