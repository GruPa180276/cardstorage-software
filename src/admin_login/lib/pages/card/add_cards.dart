import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/provider/types/cards.dart';
import 'package:admin_login/pages/widget/listTile.dart';
import 'package:admin_login/pages/widget/popupdialog.dart';
import 'package:admin_login/domain/values/card_values.dart';
import 'package:admin_login/provider/types/cards.dart' as card;
import 'package:admin_login/pages/widget/circularprogressindicator.dart';
import 'package:admin_login/provider/types/storages.dart' as storage;
import 'package:admin_login/provider/types/storages.dart';

CardValues cardValues = new CardValues();

class AddCards extends StatefulWidget {
  const AddCards({Key? key}) : super(key: key);

  @override
  State<AddCards> createState() => _AddCardsState();
}

class _AddCardsState extends State<AddCards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Karte hinzufügen",
            style: TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
          ),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          actions: []),
      body: Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: [GenerateInputFields()],
          )),
    );
  }
}

class GenerateInputFields extends StatefulWidget {
  const GenerateInputFields({Key? key}) : super(key: key);

  @override
  State<GenerateInputFields> createState() => _GenerateInputFieldsState();
}

class _GenerateInputFieldsState extends State<GenerateInputFields> {
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

    setState(() {});
  }

  void setName(String value) {
    cardValues.setName(value);
  }

  void setStorage(String value) {
    cardValues.setStorage(value);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cards>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return genereateFields(context);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(
            child: Container(
                child: Column(
          children: [
            generateProgressIndicator(context),
          ],
        )));
      },
    );
  }

  Widget genereateFields(BuildContext context) {
    return Container(
      child: Column(children: [
        GenerateListTile(
          labelText: "Name",
          hintText: "",
          icon: Icons.storage,
          regExp: r'([A-Za-z0-9\-\_\ö\ä\ü\ß ])',
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
                          style: TextStyle(color: Theme.of(context).focusColor),
                        ));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedStorage = newValue!;
                    });
                    setStorage(newValue!);
                  },
                )))
          ]),
        ),
        GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              padding: EdgeInsets.all(10),
              height: 70,
              child: Column(children: [
                generateButtonWithDialog(
                  context,
                  "Karte hinzufügen",
                  (() {
                    Cards newEntry = new Cards(
                        name: cardValues.name,
                        storage: cardValues.storageName,
                        position: 0,
                        accessed: 0,
                        available: false);
                    card.sendData(newEntry.toJson());
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          generatePopupDialog(context),
                    );
                  }),
                )
              ]),
            )),
      ]),
    );
  }
}
