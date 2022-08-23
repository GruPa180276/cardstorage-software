import 'package:flutter/material.dart';
import 'package:rfidapp/pages/Navigation/menu_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MenuNavigationDrawer(),
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            title: const Text(
              "Homepage",
            )),
        body: buildGetback(this.context));
  }

  Widget buildGetback(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: const [
          TextField(
            decoration: InputDecoration(),
          ),
          // SizedBox(
          //     width: 500,
          //     height: 60,
          //     child: OutlinedButton.icon(
          //       icon: Icon(
          //         Icons.create,
          //         color: Theme.of(context).primaryColor,
          //       ),
          //       label: Text(
          //         "Zurück",
          //         style: TextStyle(
          //           fontSize: 18,
          //           fontWeight: FontWeight.bold,
          //           color: Theme.of(context).primaryColor,
          //         ),
          //       ),
          //       onPressed: () {
          //         Navigator.of(context).pushReplacement(MaterialPageRoute(
          //             builder: (context) => const LoginScreen()));
          //       },
          //       style: ElevatedButton.styleFrom(
          //         side: BorderSide(
          //           width: 2.5,
          //           color: Theme.of(context).primaryColor,
          //         ),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(100.0),
          //         ),
          //       ),
          //     )),
        ],
      ),
    );
  }
}


// white, black, primary:, secondary: 