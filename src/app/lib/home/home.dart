import 'package:flutter/material.dart';

import '../themes.dart';
import 'tab1.dart';
import 'tab2.dart';
import 'tab3.dart';
import 'tab4.dart';
import 'tab5.dart';
import '../drawer/settings.dart';
import '../drawer/appinfo.dart';
import 'package:provider/provider.dart';
import '../color/home_color_values.dart';
import '../text/home_text_values.dart';

HomeColorProvider homeCP = new HomeColorProvider();
HomeDescrpitionProvider homeDP = new HomeDescrpitionProvider();

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
            primarySwatch: homeCP.getHeaderColor(),
          ),
          darkTheme: Mythemes.darkTheme,
          title: homeDP.getAppTitle(),
          home: MyHomePage(),
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

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(homeDP.getAppTitle())),
      body: Center(child: SelectionBar()),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: homeCP.getDrawerHeaderColor(),
                ),
                child: Image.asset(
                  homeDP.getDrawerIconPath(),
                )),
            Divider(
              color: homeCP.getDrawerHeaderDividerColor(),
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
                  Text(homeDP.getDrawerSettingsTabName(),
                      style: const TextStyle(fontSize: 20)),
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
            Divider(
              color: homeCP.getDrawerHeaderDividerColor(),
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
                  Text(homeDP.getDrawerAppInfoTabName(),
                      style: const TextStyle(fontSize: 20)),
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
            Divider(
              color: homeCP.getDrawerHeaderDividerColor(),
              height: 10,
              thickness: 2,
              indent: 5,
              endIndent: 5,
            ),
            ChangeThemeButtonWidget()
          ],
        ),
      ),
    );
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
                  labelColor: homeCP.getTabBarLabelColor(),
                  tabs: [
                    Tab(icon: Icon(Icons.home_outlined)),
                    Tab(icon: Icon(Icons.storage)),
                    Tab(icon: Icon(Icons.credit_card)),
                    Tab(icon: Icon(Icons.directions_boat)),
                    Tab(icon: Icon(Icons.directions_bus)),
                  ],
                ))),
        body: TabBarView(children: [Tab1(), Tab2(), Tab3(), Tab4(), Tab5()]),
      ),
    );
  }
}
