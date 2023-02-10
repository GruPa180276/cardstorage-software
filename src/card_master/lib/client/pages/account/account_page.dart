import 'package:flutter/material.dart';
import 'package:card_master/client/config/palette.dart';
import 'package:card_master/client/domain/authentication/user_secure_storage.dart';
import 'package:card_master/client/domain/validator.dart';
import 'package:card_master/client/pages/widgets/widget/default_custom_button.dart';
import 'package:card_master/client/pages/widgets/widget/text_field.dart';
import 'package:card_master/client/provider/session_user.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController officeLocationController = TextEditingController();
  TextEditingController privilegedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = SessionUser.getEmail()!;
    firstNameController.text = SessionUser.getUserFirstname()!;
    lastNameController.text = SessionUser.getUserLastname()!;
    officeLocationController.text = SessionUser.getUserOfficeLocation()!;
    privilegedController.text =
        (SessionUser.getPrivileged()!) ? "Adminrechte" : "Benutzerechte";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        //drawer: const MenuNavigationDrawer(),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
          toolbarHeight: 100,
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
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.all(30),
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
                  const SizedBox(
                    height: 20,
                  ),
                  TextInput(
                      iconData: Icons.person,
                      inputController: firstNameController,
                      label: 'Vorname',
                      obsecureText: false,
                      validator: Validator.funcName,
                      editable: false),
                  const SizedBox(
                    height: 20,
                  ),
                  TextInput(
                      iconData: Icons.person,
                      inputController: lastNameController,
                      label: 'Nachname',
                      obsecureText: false,
                      validator: Validator.funcName,
                      editable: false),
                  const SizedBox(
                    height: 20,
                  ),
                  TextInput(
                      iconData: Icons.email,
                      inputController: emailController,
                      label: 'E-Mail',
                      obsecureText: false,
                      validator: Validator.funcEmail,
                      editable: false),
                  const SizedBox(
                    height: 20,
                  ),
                  TextInput(
                      iconData: Icons.room,
                      inputController: officeLocationController,
                      label: 'Raum',
                      obsecureText: false,
                      validator: Validator.funcEmail,
                      editable: false),
                  const SizedBox(
                    height: 20,
                  ),
                  TextInput(
                      iconData: Icons.lock,
                      inputController: privilegedController,
                      label: 'Rechte',
                      obsecureText: false,
                      validator: Validator.funcEmail,
                      editable: false),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                        height: 50,
                        child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: DefaultCustomButton(
                              bgColor: ColorSelect.blueAccent,
                              borderColor: ColorSelect.blueAccent,
                              text: 'Zurueck',
                              textColor: Colors.white,
                              onPress: () {
                                Navigator.pop(context);
                              },
                            )),
                      ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
