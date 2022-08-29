import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app/config/themes.dart';

import 'package:app/pages/home/tab1.dart';
import 'package:app/pages/storage/tab2.dart';
import 'package:app/pages/card/tab3.dart';
import 'package:app/pages/user/tab4.dart';
import 'package:app/pages/right/tab5.dart';

import 'package:app/pages/drawer/settings.dart';
import 'package:app/pages/drawer/appinfo.dart';

import '../config/color_values/tab1_color_values.dart';
import '../config/text_values/tab1_text_values.dart';

Tab1ColorProvider homeColorProvider = new Tab1ColorProvider();
Tab1TextValues homeTextProvider = new Tab1TextValues();

void main() => runApp(Home());

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);

        return MaterialApp(
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            primarySwatch: homeColorProvider.getHeaderColor(),
          ),
          darkTheme: Mythemes.darkTheme,
          title: homeTextProvider.getAppTitle(),
          home: HomePage(),
          debugShowCheckedModeBanner: false,
        );
      });
}

class ChangeThemeButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch.adaptive(
      value: themeProvider.isDarkMode,
      onChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(homeTextProvider.getAppTitle()),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout,
              ),
              onPressed: () {
                // ToDo: Call Login Page from GruPa
              },
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Icon(Icons.refresh),
                ),
              ),
            ),
          ],
        ),
        body: Center(child: SelectionBar()),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                  "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fwww.pngmart.com%2Ffiles%2F10%2FBusiness-User-Account-PNG-File.png&f=1&nofb=1",
                )),
                accountEmail: Text('benedikt.zoechmann@protonmail.com'),
                accountName: Text(
                  'Benedikt Zöchmann',
                  style: TextStyle(fontSize: 24.0),
                ),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text(
                  'Settings',
                  style: TextStyle(fontSize: 24.0),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const Settings(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text(
                  'App Info',
                  style: TextStyle(fontSize: 24.0),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const AppInfo(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.query_stats),
                title: const Text(
                  'Stats',
                  style: TextStyle(fontSize: 24.0),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => HomePage(),
                    ),
                  );
                },
              ),
              const Divider(
                height: 10,
                thickness: 1,
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text(
                  'Exit',
                  style: TextStyle(fontSize: 24.0),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const HomePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}

class SelectionBar extends StatefulWidget {
  SelectionBar({Key? key}) : super(key: key) {}

  @override
  State<SelectionBar> createState() => _SelectionBarState();
}

class _SelectionBarState extends State<SelectionBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Container(
                height: 50,
                child: TabBar(
                  labelColor: homeColorProvider.getTabBarLabelColor(),
                  tabs: [
                    Tab(icon: Icon(Icons.home_outlined)),
                    Tab(icon: Icon(Icons.storage)),
                    Tab(icon: Icon(Icons.credit_card)),
                    Tab(icon: Icon(Icons.person)),
                    Tab(icon: Icon(Icons.task)),
                  ],
                ))),
        body: TabBarView(children: [Tab1(), Tab2(), Tab3(), Tab4(), Tab5()]),
      ),
    );
  }
}
