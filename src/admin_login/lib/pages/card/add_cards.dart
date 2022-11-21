import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/pages/widget/data.dart';
import 'package:admin_login/pages/widget/listTile.dart';
import 'package:admin_login/domain/values/card_values.dart';
import 'package:admin_login/pages/widget/circularprogressindicator.dart';

// ToDo: The needs to be pushed to the API
// Add API call to select the Card Storage

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
              style:
                  TextStyle(color: Theme.of(context).focusColor, fontSize: 25),
            ),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            actions: []),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: [GenerateInputFields()],
              )),
        ));
  }
}

class GenerateInputFields extends StatefulWidget {
  const GenerateInputFields({Key? key}) : super(key: key);

  @override
  State<GenerateInputFields> createState() => _GenerateInputFieldsState();
}

class _GenerateInputFieldsState extends State<GenerateInputFields> {
  late Future<List<Cards>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData("cards") as Future<List<Cards>>;
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
          regExp: r'([A-Za-z\-\_\ö\ä\ü\ß ])',
          function: this.setName,
        ),
        GenerateListTile(
          labelText: "Karten Tresor",
          hintText: "",
          icon: Icons.description,
          regExp: r'([A-Za-z\-\_\ö\ä\ü\ß ])',
          function: this.setStorage,
        ),
        Container(
          padding: EdgeInsets.all(10),
          height: 70,
          child: Column(children: [
            SizedBox(
              height: 50,
              width: double.infinity,
              child: generateButtonWithDialog(context, "Bitte Karte scannen"),
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
                    "Karte hinzufügen",
                    cardValues,
                    () {
                      Cards newEntry = new Cards(
                          id: cardValues.id,
                          name: cardValues.name,
                          storageID: cardValues.storageID,
                          hardwareID: cardValues.hardwareID);
                      sendData("cards", newEntry.toJson());
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ]),
            )),
      ]),
    );
  }
}
