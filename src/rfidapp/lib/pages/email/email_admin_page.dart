import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:rfidapp/domain/validator.dart';
import 'package:rfidapp/pages/generate/widget/button_create.dart';
import 'package:rfidapp/pages/generate/widget/textInputField.dart';

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
            TextInput(
                inputController: titleController,
                label: "Titel EIngeben",
                iconData: Icons.title,
                validator: Validator.funcNotEmpty,
                obsecureText: false),
            TextFormField(
              minLines: 2,
              maxLines: 5,
              controller: descriptionController,
              keyboardType: TextInputType.multiline,
              decorati
              on: InputDecoration(
                hintText: 'descrsiption',
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
