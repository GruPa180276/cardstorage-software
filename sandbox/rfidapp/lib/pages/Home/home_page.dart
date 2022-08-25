import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 125,
            bottomOpacity: 0.0,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            title: Text("Homepage",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).primaryColor))),
        body: buildGetback(this.context));
  }

  Widget buildGetback(BuildContext context) {
    return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Table(
          children: const [
            TableRow(
              children: [
                TableCell(child: Text("ID:")),
                TableCell(child: Text("ID:")),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Text("Name:")),
                TableCell(child: Text("ID:")),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Text("StorageId:")),
                TableCell(child: Text("ID:")),
              ],
            ),
            TableRow(
              children: [
                TableCell(child: Text("Verfuegbar:")),
                TableCell(child: Text("ID:")),
              ],
            )
          ],
        ));
  }
}


// white, black, primary:, secondary: 