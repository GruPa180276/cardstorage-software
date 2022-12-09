import 'package:admin_login/domain/values/location_values.dart';
import 'package:admin_login/provider/types/locations.dart' as location;
import 'package:admin_login/provider/types/locations.dart';
import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/pages/widget/listTile.dart';
import 'package:admin_login/pages/widget/circularprogressindicator.dart';

// ToDo: The needs to be pushed to the API

LocationValues locationValues = new LocationValues();

class AddLocation extends StatefulWidget {
  const AddLocation({Key? key}) : super(key: key);

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Storage hinzufügen",
                style: TextStyle(color: Theme.of(context).focusColor)),
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            actions: []),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: [InputFields()],
              )),
        ));
  }
}

class InputFields extends StatefulWidget {
  const InputFields({Key? key}) : super(key: key);

  @override
  State<InputFields> createState() => _InputFieldsState();
}

class _InputFieldsState extends State<InputFields> {
  late Future<List<Locations>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  void setName(String value) {
    locationValues.setName(value);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Locations>>(
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
          state: true,
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
                    "Location hinzufügen",
                    () {
                      Locations newEntry = new Locations(
                        id: 0,
                        location: locationValues.name,
                      );
                      location.sendData(newEntry.toJson());
                      Navigator.of(context).pushNamed("/addStorage");
                    },
                  ),
                )
              ]),
            )),
      ]),
    );
  }
}
