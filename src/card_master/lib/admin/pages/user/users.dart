import 'package:flutter/material.dart';

import 'package:card_master/admin/provider/types/user.dart';
import 'package:card_master/admin/pages/widget/createUser.dart';
import 'package:card_master/admin/pages/widget/reloadbutton.dart';

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
    await fetchUsers().then((value) => listOfCards = value);

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
          title: Text("Benutzer",
              style:
                  TextStyle(color: Theme.of(context).focusColor, fontSize: 25)),
        ),
        body: Container(
          padding: EdgeInsets.all(5),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: txtQuery,
                            onChanged: search,
                            decoration: InputDecoration(
                              hintText: "Search",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
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
                    )),
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
            String mail = person.email;
            Color color = Colors.green;

            if (person.privileged == false) {
              color = Colors.red;
            }
            return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipPath(
                    clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: InkWell(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                              right: BorderSide(
                                color: color,
                                width: 10,
                              ),
                            )),
                            padding: EdgeInsets.all(15),
                            child: Row(children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 0,
                                  right: 15,
                                ),
                                child:
                                    Icon(Icons.account_box_outlined, size: 50),
                              ),
                              Expanded(
                                child: createUserTable(
                                  context,
                                  person.email,
                                  person.privileged,
                                ),
                              ),
                            ])),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    title: Text(
                                      'Berechtigungen ändern',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    content: new Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Wollen Sie diesen Benutzer zu einem Admin machen?",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
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
                                                  onPressed: () async {
                                                    Users user = new Users(
                                                      email: person.email,
                                                      storage: person.storage,
                                                      privileged: true,
                                                    );

                                                    Future<int> code =
                                                        updateData(person.email,
                                                            user.toJson());

                                                    if (await code == 200) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                                backgroundColor:
                                                                    Theme.of(
                                                                            context)
                                                                        .scaffoldBackgroundColor,
                                                                title: Text(
                                                                  'Priviledge User',
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor),
                                                                ),
                                                                content:
                                                                    new Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      "User ist jetzt Admin!",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Theme.of(context).primaryColor),
                                                                    ),
                                                                  ],
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10),
                                                                      height:
                                                                          70,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(children: [
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: Text(
                                                                                "Finish",
                                                                                style: TextStyle(color: Theme.of(context).focusColor),
                                                                              ),
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Theme.of(context).secondaryHeaderColor,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                        ],
                                                                      )),
                                                                ],
                                                              ));
                                                    }
                                                    if (await code == 400) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                                backgroundColor:
                                                                    Theme.of(
                                                                            context)
                                                                        .scaffoldBackgroundColor,
                                                                title: Text(
                                                                  'Privilege User',
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor),
                                                                ),
                                                                content:
                                                                    new Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      "Es ist ein Fehler aufgetreten!",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Theme.of(context).primaryColor),
                                                                    ),
                                                                  ],
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10),
                                                                      height:
                                                                          70,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(children: [
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: Text(
                                                                                "Finish",
                                                                                style: TextStyle(color: Theme.of(context).focusColor),
                                                                              ),
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Theme.of(context).secondaryHeaderColor,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                        ],
                                                                      )),
                                                                ],
                                                              ));
                                                    }
                                                  },
                                                  child: Text(
                                                    "Ja",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .focusColor),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .secondaryHeaderColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .scaffoldBackgroundColor,
                                                              title: Text(
                                                                'User löschen',
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor),
                                                              ),
                                                              content:
                                                                  new Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "Wollen Sie diesen User löschen?",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                  ),
                                                                ],
                                                              ),
                                                              actions: <Widget>[
                                                                Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    height: 70,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Row(
                                                                            children: [
                                                                              ElevatedButton(
                                                                                onPressed: () async {
                                                                                  Future<int> code = deleteUser(mail);

                                                                                  if (await code == 200) {
                                                                                    Navigator.of(context).pop();
                                                                                    showDialog(
                                                                                        context: context,
                                                                                        builder: (BuildContext context) => AlertDialog(
                                                                                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                                                                              title: Text(
                                                                                                'Delete User',
                                                                                                style: TextStyle(color: Theme.of(context).primaryColor),
                                                                                              ),
                                                                                              content: new Column(
                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: <Widget>[
                                                                                                  Text(
                                                                                                    "User ist gelöscht!",
                                                                                                    style: TextStyle(color: Theme.of(context).primaryColor),
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
                                                                                                              Navigator.of(context).pop();
                                                                                                            },
                                                                                                            child: Text(
                                                                                                              "Finish",
                                                                                                              style: TextStyle(color: Theme.of(context).focusColor),
                                                                                                            ),
                                                                                                            style: ElevatedButton.styleFrom(
                                                                                                              backgroundColor: Theme.of(context).secondaryHeaderColor,
                                                                                                              shape: RoundedRectangleBorder(
                                                                                                                borderRadius: BorderRadius.circular(8),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ]),
                                                                                                      ],
                                                                                                    )),
                                                                                              ],
                                                                                            ));
                                                                                  }
                                                                                  if (await code == 400) {
                                                                                    Navigator.of(context).pop();
                                                                                    showDialog(
                                                                                        context: context,
                                                                                        builder: (BuildContext context) => AlertDialog(
                                                                                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                                                                              title: Text(
                                                                                                'Delete User',
                                                                                                style: TextStyle(color: Theme.of(context).primaryColor),
                                                                                              ),
                                                                                              content: new Column(
                                                                                                mainAxisSize: MainAxisSize.min,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: <Widget>[
                                                                                                  Text(
                                                                                                    "Es ist ein Fehler aufgetreten!",
                                                                                                    style: TextStyle(color: Theme.of(context).primaryColor),
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
                                                                                                              Navigator.of(context).pop();
                                                                                                            },
                                                                                                            child: Text(
                                                                                                              "Finish",
                                                                                                              style: TextStyle(color: Theme.of(context).focusColor),
                                                                                                            ),
                                                                                                            style: ElevatedButton.styleFrom(
                                                                                                              backgroundColor: Theme.of(context).secondaryHeaderColor,
                                                                                                              shape: RoundedRectangleBorder(
                                                                                                                borderRadius: BorderRadius.circular(8),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ]),
                                                                                                      ],
                                                                                                    )),
                                                                                              ],
                                                                                            ));
                                                                                  }
                                                                                  ;
                                                                                },
                                                                                child: Text(
                                                                                  "Ja",
                                                                                  style: TextStyle(color: Theme.of(context).focusColor),
                                                                                ),
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(8),
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
                                                                                  style: TextStyle(color: Theme.of(context).focusColor),
                                                                                ),
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Theme.of(context).secondaryHeaderColor,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ]),
                                                                      ],
                                                                    )),
                                                              ],
                                                            ));
                                                  },
                                                  child: Text(
                                                    "Löschen",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .focusColor),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .secondaryHeaderColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
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
                                                        color: Theme.of(context)
                                                            .focusColor),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Theme.of(
                                                            context)
                                                        .secondaryHeaderColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            ],
                                          )),
                                    ],
                                  ));
                        })));
          }),
    );
  }
}
