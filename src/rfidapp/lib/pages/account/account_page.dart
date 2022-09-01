import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  TextEditingController emailController = TextEditingController()
    ..text = 'Get data';
  TextEditingController firstName = TextEditingController()..text = 'Get data';
  TextEditingController lastName = TextEditingController()..text = 'Get data';
  TextEditingController birthDate = TextEditingController()..text = 'Get data';

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        //drawer: const MenuNavigationDrawer(),
        appBar: AppBar(
          toolbarHeight: 125,
          bottomOpacity: 0.0,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text("Account",
              style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: ColorSelect.greyBorderColor,
                    child: const Icon(
                      Icons.account_box,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                ),
                buildTexfield(
                    context,
                    "Vorname",
                    firstName,
                    const Icon(
                      Icons.person,
                      size: 27,
                    )),
                buildTexfield(context, "Nachname", lastName,
                    const Icon(Icons.person, size: 27)),
                buildTexfield(context, "E-Mail", emailController,
                    const Icon(Icons.email, size: 27)),
                const SizedBox(height: 35),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: buildButton('Passwort aendern')),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                            height: 50, child: buildButton('Abbrechen'))),
                    const SizedBox(width: 20),
                    Expanded(
                        child: SizedBox(
                            height: 50, child: buildButton('Speichern')))
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Widget buildTexfield(BuildContext context, String text,
      TextEditingController editingController, Icon icon) {
    return Container(
      padding: const EdgeInsets.only(top: 35, left: 0, right: 0),
      child: TextField(
        controller: editingController,
        decoration: InputDecoration(
          //hintText: "Get User Data",
          labelText: text,
          prefixIcon: icon,
        ),
      ),
    );
  }

  Widget buildButton(String text) {
    Color colorbg = ColorSelect.blueAccent;
    Color colorText = Colors.white;
    Color colorBorder = ColorSelect.blueAccent;

    if (text == 'Abbrechen') {
      colorbg = Theme.of(context).scaffoldBackgroundColor;
      colorText = Theme.of(context).primaryColor;
      colorBorder = Theme.of(context).primaryColor;
    }

    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(colorbg),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  side: BorderSide(color: colorBorder, width: 2.2)))),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: colorText,
        ),
      ),
    );
  }
}
