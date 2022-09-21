import 'package:admin_login/pages/widget/appbar_back.dart';
import 'package:flutter/material.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({Key? key}) : super(key: key);

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  @override
  void initState() {
    super.initState();
  }

  void setName(String value) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateAppBarBack(context),
      body: Container(
          child: Column(
        children: [genereateFields(context)],
      )),
    );
  }

  Widget genereateFields(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          Center(
              child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade600,
            child: const Icon(
              Icons.account_box,
              size: 70,
              color: Colors.white,
            ),
          )),
          SizedBox(
            height: 10,
          ),
          Text("Test User", style: TextStyle(fontSize: 20)),
          SizedBox(
            height: 10,
          ),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Icon(
                Icons.mail,
                size: 40,
              ),
              title: Text('Mail'),
              subtitle: Text('testuser@xyz.com'),
            ),
          ),
        ]));
  }
}
