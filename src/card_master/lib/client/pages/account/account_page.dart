import 'package:card_master/client/provider/size/size_extentions.dart';
import 'package:flutter/material.dart';
import 'package:card_master/client/config/palette.dart';
import 'package:card_master/client/domain/validator.dart';
import 'package:card_master/client/pages/widgets/widget/default_custom_button.dart';
import 'package:card_master/client/pages/widgets/widget/text_field.dart';
import 'package:card_master/client/domain/authentication/user_session_manager.dart';

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
    emailController.text = UserSessionManager.getEmail()!;
    firstNameController.text = UserSessionManager.getUserFirstname()!;
    lastNameController.text = UserSessionManager.getUserLastname()!;
    officeLocationController.text = UserSessionManager.getUserOfficeLocation()!;
    privilegedController.text =
        (UserSessionManager.getPrivileged()!) ? "Adminrechte" : "Benutzerechte";
  }

  @override
  Widget build(BuildContext context) {
    var sizedHeight = 2.0.hs;
    return Scaffold(

        //drawer: const MenuNavigationDrawer(),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor, //change your color here
          ),
          toolbarHeight: 10.0.hs,
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
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5.0.ws),
          child: Padding(
            padding: EdgeInsets.all(10.0.ws),
            child: Column(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 7.0.fs,
                    backgroundColor: ColorSelect.greyBorderColor,
                    child: Icon(
                      Icons.account_box,
                      size: 8.0.fs,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: sizedHeight,
                ),
                TextInput(
                    iconData: Icons.person,
                    inputController: firstNameController,
                    label: 'Vorname',
                    obsecureText: false,
                    validator: Validator.funcName,
                    editable: false),
                SizedBox(
                  height: sizedHeight,
                ),
                TextInput(
                    iconData: Icons.person,
                    inputController: lastNameController,
                    label: 'Nachname',
                    obsecureText: false,
                    validator: Validator.funcName,
                    editable: false),
                SizedBox(
                  height: sizedHeight,
                ),
                TextInput(
                    iconData: Icons.email,
                    inputController: emailController,
                    label: 'E-Mail',
                    obsecureText: false,
                    validator: Validator.funcEmail,
                    editable: false),
                SizedBox(
                  height: sizedHeight,
                ),
                TextInput(
                    iconData: Icons.room,
                    inputController: officeLocationController,
                    label: 'Raum',
                    obsecureText: false,
                    validator: Validator.funcEmail,
                    editable: false),
                SizedBox(
                  height: sizedHeight,
                ),
                TextInput(
                    iconData: Icons.lock,
                    inputController: privilegedController,
                    label: 'Rechte',
                    obsecureText: false,
                    validator: Validator.funcEmail,
                    editable: false),
                SizedBox(
                  height: sizedHeight,
                ),
                SizedBox(height: sizedHeight),
                Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                            width: double.infinity,
                            height: 7.0.fs,
                            child: DefaultCustomButton(
                              bgColor: ColorSelect.blueAccent,
                              borderColor: ColorSelect.blueAccent,
                              text: 'Zurück',
                              textColor: Colors.white,
                              onPress: () {
                                Navigator.pop(context);
                              },
                            )))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
