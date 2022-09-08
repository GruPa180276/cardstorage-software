import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/data.dart';
import 'package:admin_login/pages/widget/button.dart';
import 'package:admin_login/pages/widget/listTile.dart';
import 'package:admin_login/domain/values/user_values.dart.dart';
import 'package:admin_login/pages/widget/circularprogressindicator.dart';

// ToDo: The needs to be pushed to the API

UserValues userValues = new UserValues();

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Benutzer hinzufügen",
              style: TextStyle(color: Theme.of(context).focusColor),
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
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  void setFirstName(String value) {
    userValues.setFirstName(value);
  }

  void setLastName(String value) {
    userValues.setLastName(value);
  }

  void setMail(String value) {
    userValues.setUserMail(value);
  }

  void setPhoneNumber(String value) {
    userValues.setPhoneNumber(value);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Data>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Data>? data = snapshot.data;
          return genereateFields(context, data);
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

  Widget genereateFields(BuildContext context, List<Data>? data) {
    return Container(
      child: Column(children: [
        GenerateListTile(
          labelText: "Vorname",
          hintText: "",
          icon: Icons.description,
          regExp: r'([A-Za-z\-\_\ö\ä\ü\ß ])',
          function: this.setFirstName,
        ),
        GenerateListTile(
          labelText: "Nachname",
          hintText: "",
          icon: Icons.description,
          regExp: r'([A-Za-z\-\_\ö\ä\ü\ß ])',
          function: this.setLastName,
        ),
        GenerateListTile(
          labelText: "Email",
          hintText: "",
          icon: Icons.mail,
          regExp: r'([A-Za-z0-9\-\_\@\.\ö\ä\ü\ß ])',
          function: this.setMail,
        ),
        GenerateListTile(
          labelText: "Telefonnummer",
          hintText: "",
          icon: Icons.phone,
          regExp: r'([0-9\- ])',
          function: this.setPhoneNumber,
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
                  child: generateButtonRectangle(context, "User hinzufügen"),
                )
              ]),
            )),
      ]),
    );
  }
}
