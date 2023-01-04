import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/provider/types/cards.dart';
import 'package:admin_login/pages/widget/listTile.dart';
import 'package:admin_login/domain/values/card_values.dart';
import 'package:admin_login/provider/types/cards.dart' as card;
import 'package:admin_login/provider/types/storages.dart' as storage;
import 'package:admin_login/provider/types/storages.dart';

CardValues cardValues = new CardValues();
late Future<List<Cards>> futureData;

class CardSettings extends StatefulWidget {
  CardSettings(String card, {Key? key}) : super(key: key) {
    cardValues.setName(card);
  }

  @override
  State<CardSettings> createState() => _CardSettingsState();
}

class _CardSettingsState extends State<CardSettings> {
  void setName(String value) {
    cardValues.setName(value);
  }

  @override
  void initState() {
    super.initState();
    futureData = card.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Karte bearbeiten",
              style:
                  TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
            ),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            actions: []),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: [GetDataFromAPI()],
              )),
        ));
  }
}

class GetDataFromAPI extends StatefulWidget {
  const GetDataFromAPI({Key? key}) : super(key: key);

  @override
  State<GetDataFromAPI> createState() => _GetDataFromAPIState();
}

class _GetDataFromAPIState extends State<GetDataFromAPI> {
  late Future<List<Cards>> futureData;

  String selectedStorage = "-";
  List<String> dropDownValuesNames = ["-"];
  List<Storages>? listOfStorages;

  @override
  void initState() {
    super.initState();
    futureData = card.fetchData();
    test();
  }

  void test() async {
    await storage.fetchData().then((value) => listOfStorages = value);

    for (int i = 0; i < listOfStorages!.length; i++) {
      dropDownValuesNames.add(listOfStorages![i].name);
    }
  }

  void setName(String value) {
    cardValues.setName(value);
  }

  void setStorage(int value) {
    cardValues.setStorage(value);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cards>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Cards>? data = snapshot.data;
          return genereateFields(context, data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(
            child: Container(
                child: Column(
          children: [
            CircularProgressIndicator(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              valueColor: AlwaysStoppedAnimation(Theme.of(context).focusColor),
            )
          ],
        )));
      },
    );
  }

  Widget genereateFields(BuildContext context, List<Cards>? data) {
    return InkWell(
        child: Container(
      child: Column(children: [
        GenerateListTile(
          labelText: "Name",
          hintText: cardValues.name,
          icon: Icons.description,
          regExp: r'([A-Za-z\-\_\ö\ä\ü\ß ])',
          function: this.setName,
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: Column(children: [
            DecoratedBox(
                decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    border: Border.all(
                      color: Colors.black38,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.57),
                        blurRadius: 5,
                      )
                    ]),
                child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: Center(
                        child: DropdownButton(
                      focusColor: Theme.of(context).focusColor,
                      dropdownColor: Theme.of(context).backgroundColor,
                      iconEnabledColor: Theme.of(context).focusColor,
                      iconDisabledColor: Theme.of(context).focusColor,
                      value: selectedStorage,
                      items: dropDownValuesNames.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem,
                            child: Text(
                              valueItem.toString(),
                              style: TextStyle(
                                  color: Theme.of(context).focusColor),
                            ));
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedStorage = newValue as String;
                        });
                        int index =
                            dropDownValuesNames.indexOf(newValue as String);
                        setStorage(int.parse(dropDownValuesNames[index]));
                      },
                    ))))
          ]),
        ),
        GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              padding: EdgeInsets.all(10),
              height: 70,
              child: Column(children: [
                generateButtonRectangle(
                  context,
                  "Änderungen speichern",
                  () {
                    Cards updateEntry = new Cards(
                      name: cardValues.name,
                      storage: cardValues.storageID,
                    );
                    card.updateData(cardValues.name, updateEntry.toJson());
                    Navigator.of(context).pop();
                  },
                ),
              ]),
            )),
      ]),
    ));
  }
}
