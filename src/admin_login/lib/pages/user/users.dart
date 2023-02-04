import 'package:flutter/material.dart';

import 'package:admin_login/provider/types/user.dart';
import 'package:admin_login/pages/widget/reloadbutton.dart';
import 'package:admin_login/pages/widget/cardwithoutinkwell.dart';

class UsersSettings extends StatefulWidget {
  UsersSettings({Key? key}) : super(key: key);

  @override
  State<UsersSettings> createState() => _StorageViewState();
}

class _StorageViewState extends State<UsersSettings> {
  late List<Users> listOfCards = [];
  List<Users> persons = [];
  List<Users> original = [];
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
    List<Users> result = [];
    for (int i = 0; i < persons.length; i++) {
      var name = persons[i].email.toString().toLowerCase();
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

  void reload() {
    setState(() {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: GenerateReloadButton(this.reload),
        appBar: AppBar(
          title: Text("Karten entfernen",
              style:
                  TextStyle(color: Theme.of(context).focusColor, fontSize: 25)),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
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
        ));
  }

  Widget _listView(List<Users> persons) {
    return Expanded(
      child: ListView.builder(
          itemCount: persons.length,
          itemBuilder: (context, index) {
            Users person = persons[index];
            return GenerateCardWithoutInkWell(
              name: person.email,
              icon: Icons.account_box_outlined,
              onpressd: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          title: Text(
                            'Berechtigungen ändern',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          content: new Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Wollen Sie diesen Bnutzer zu einem Admin machen?",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            Container(
                                padding: EdgeInsets.all(10),
                                height: 70,
                                child: Column(
                                  children: [
                                    Row(children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Users user = new Users(
                                            email: person.email,
                                            privileged: true,
                                          );

                                          updateData(
                                              person.email, user.toJson());

                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Ja",
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).focusColor),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .secondaryHeaderColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Nein",
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).focusColor),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .secondaryHeaderColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      )
                                    ]),
                                  ],
                                )),
                          ],
                        ));
              },
            );
          }),
    );
  }
}
