import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/data.dart';
import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/pages/widget/listTile.dart';
import 'package:admin_login/domain/values/card_values.dart';

// ToDo: The Api needs to be changed in the future
// Add API call to select the Card Storage

CardValues cardValues = new CardValues();

class CardSettings extends StatefulWidget {
  CardSettings(int card, {Key? key}) : super(key: key) {
    cardValues.setID(card);
  }

  @override
  State<CardSettings> createState() => _CardSettingsState();
}

class _CardSettingsState extends State<CardSettings> {
  void setName(String value) {
    cardValues.setName(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Karten Einstellungen",
              style: TextStyle(color: Theme.of(context).focusColor),
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
  late Future<List<dynamic>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData("card", Cards);
  }

  void setName(String value) {
    cardValues.setName(value);
  }

  void setStorage(int value) {
    cardValues.setStorage(value);
  }

  void setHardwareID(int value) {
    cardValues.setHardwareID(value);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic>? data = snapshot.data;
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

  Widget genereateFields(BuildContext context, List<dynamic>? data) {
    return InkWell(
        child: Container(
      child: Column(children: [
        GenerateListTile(
          labelText: "ID",
          hintText: data![cardValues.getId()].id.toString(),
          icon: Icons.description,
          regExp: r'([A-Za-z\-\_\ö\ä\ü\ß ])',
          function: this.setName,
        ),
        GenerateListTile(
          labelText: "Name",
          hintText: data[cardValues.getId()].name,
          icon: Icons.description,
          regExp: r'([A-Za-z\-\_\ö\ä\ü\ß ])',
          function: this.setName,
        ),
        GenerateListTile(
          labelText: "Karten Tresor",
          hintText: data[cardValues.getId()].storageID.toString(),
          icon: Icons.storage,
          regExp: r'([A-Za-z\-\_\ö\ä\ü\ß ])',
          function: this.setStorage,
        ),
        GenerateListTile(
          labelText: "Karten Nummer",
          hintText: data[cardValues.getId()].hardwareID.toString(),
          icon: Icons.storage,
          regExp: r'([A-Za-z\-\_\ö\ä\ü\ß ])',
          function: this.setHardwareID,
        ),
        Container(
          padding: EdgeInsets.all(10),
          height: 70,
          child: Column(children: [
            SizedBox(
              height: 50,
              width: double.infinity,
              child: GenerateButtonWithDialogAndCallBack(
                buttonText: "Bitte Karte scannen",
                function: this.setHardwareID,
              ),
            )
          ]),
        ),
        GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              padding: EdgeInsets.all(10),
              height: 70,
              child: Column(children: [
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: generateButtonRectangle(
                    context,
                    "Änderungen speichern",
                    cardValues,
                    () {
                      Cards updateEntry = new Cards(
                          id: cardValues.id,
                          name: cardValues.name,
                          storageID: cardValues.storageID,
                          hardwareID: cardValues.hardwareID);
                      updateData("cards", updateEntry.toJson());
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ]),
            )),
      ]),
    ));
  }
}
