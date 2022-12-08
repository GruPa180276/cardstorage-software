import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/domain/validator.dart';
import 'package:rfidapp/pages/generate/widget/button_create.dart';

class EmailAdminScreen extends StatefulWidget {
  const EmailAdminScreen({super.key});

  @override
  State<EmailAdminScreen> createState() => _EmailAdminScreenState();
}

class _EmailAdminScreenState extends State<EmailAdminScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 100,
            title: Text("Frage Stellen",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).primaryColor)),
            iconTheme: IconThemeData(
              color: Theme.of(context).primaryColor, //change your color here
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Problemstellung',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              minLines: 1,
              maxLines: 50,
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'Beschreibung',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: buttonField(
                      bgColor: ColorSelect.blueAccent,
                      onPress: () {},
                      text: "Nachricht senden",
                      borderColor: ColorSelect.blueAccent,
                      textColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ));
  }
}
