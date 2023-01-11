import 'package:admin_login/pages/widget/cardwithoutinkwell.dart';
import 'package:flutter/material.dart';

import 'package:admin_login/provider/types/cards.dart';

class RemoveCards extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<RemoveCards> {
  late List<Cards> listOfCards = [];
  List<Cards> persons = [];
  List<Cards> original = [];
  TextEditingController txtQuery = new TextEditingController();

  void loadData() async {
    await fetchData().then((value) => listOfCards = value);

    persons = listOfCards;
    original = listOfCards;
    setState(() {});
  }

  void search(String query) {
    if (query.isEmpty) {
      persons = original;
      setState(() {});
      return;
    }

    query = query.toLowerCase();
    print(query);
    List<Cards> result = [];
    for (int i = 0; i < persons.length; i++) {
      var name = persons[i].name.toString().toLowerCase();
      if (name.contains(query)) {
        result.add(persons[i]);
      }
    }

    persons = result;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Karten entfernen",
            style:
                TextStyle(color: Theme.of(context).focusColor, fontSize: 25)),
      ),
      body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: txtQuery,
                    onChanged: search,
                    decoration: InputDecoration(
                      hintText: "Search",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          txtQuery.text = '';
                          search(txtQuery.text);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _listView(persons)
          ]),
    );
  }

  Widget _listView(List<Cards> persons) {
    return Expanded(
      child: ListView.builder(
          itemCount: persons.length,
          itemBuilder: (context, index) {
            Cards person = persons[index];
            return GenerateCardWithoutInkWell(
              name: person.name,
              icon: Icons.credit_card,
              onpressd: () {
                deleteData(person.name);
              },
            );
          }),
    );
  }
}
