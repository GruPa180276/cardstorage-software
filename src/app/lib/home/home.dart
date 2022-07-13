import 'package:flutter/material.dart';

import 'tab1.dart';
import 'tab2.dart';
import 'tab3.dart';
import 'tab4.dart';
import 'tab5.dart';
import '../drawer/settings.dart';
import '../drawer/appinfo.dart';

void main() => runApp(const Home());

class Home extends StatelessWidget {
  const Home({super.key});

  static const appTitle = 'Card-View';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      title: appTitle,
      home: const MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(child: SelectionBar()),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Image.asset(
                  "img/splashscreen.jpg",
                )),
            const Divider(
              color: Colors.grey,
              height: 10,
              thickness: 2,
              indent: 5,
              endIndent: 5,
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.all(15),
                alignment: Alignment.topLeft,
                child: Column(children: [
                  Text('Settings', style: const TextStyle(fontSize: 20)),
                ]),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Settings(),
                    ));
              },
            ),
            const Divider(
              color: Colors.grey,
              height: 10,
              thickness: 2,
              indent: 5,
              endIndent: 5,
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.all(15),
                alignment: Alignment.topLeft,
                child: Column(children: [
                  Text('App Info', style: const TextStyle(fontSize: 20)),
                ]),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppInfo(),
                    ));
              },
            ),
            const Divider(
              color: Colors.grey,
              height: 10,
              thickness: 2,
              indent: 5,
              endIndent: 5,
            ),
          ],
        ),
      ),
    );
  }
}

class SelectionBar extends StatelessWidget {
  const SelectionBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: TabBar(
            labelColor: Colors.blue,
            tabs: [
              Tab(icon: Icon(Icons.credit_card)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
              Tab(icon: Icon(Icons.directions_boat)),
              Tab(icon: Icon(Icons.directions_bus)),
            ],
          ),
        ),
        body: TabBarView(
          children: [Tab1(), Tab2(), Tab3(), Tab4(), Tab5()],
        ),
      ),
    );
  }
}
