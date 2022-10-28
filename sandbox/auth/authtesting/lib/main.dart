import 'dart:io';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() => runApp(MyApp());

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AAD OAuth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'AAD OAuth Home'),
      navigatorKey: navigatorKey,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? accessToken;
  late AadOAuth oauth;

  @override
  void initState() {
    getEnv();
  }

  void getEnv() async {
    await dotenv.load(fileName: "assets/.env");
    oauth = AadOAuth(config);
  }

  static final Config config = Config(
    tenant: dotenv.env['tenant']!,
    clientId: dotenv.env['clientId']!,
    scope: 'User.Read',
    redirectUri: 'cardstorage://auth',
    navigatorKey: navigatorKey,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'AzureAD OAuth',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.launch),
            title: const Text('Login'),
            onTap: () {
              login();
            },
          ),
          ListTile(
            leading: const Icon(Icons.handshake),
            title: const Text('Fetch Data'),
            onTap: () async {
              const String apiUrl = 'https://graph.microsoft.com/v1.0/me';
              final response = await http.get(Uri.parse(apiUrl), headers: {
                HttpHeaders.authorizationHeader: "Bearer $accessToken"
              });
              if (response.statusCode == 201) {
                final String responseString = response.body;

                print('$responseString');
              } else {
                print(response.body);
                return null;
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Logout'),
            onTap: () async {
              oauth.logout();
            },
          ),
        ],
      ),
    );
  }

  void showError(dynamic ex) {
    showMessage(ex.toString());
  }

  void showMessage(String text) {
    var alert = AlertDialog(content: Text(text), actions: <Widget>[
      TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
          })
    ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void login() async {
    try {
      await oauth.login();
      String? accessoken = await oauth.getAccessToken();

      setState(() {
        accessToken = accessoken;
      });
    } catch (e) {
      showError(e);
    }
  }

  void logout() async {
    await oauth.logout();
    showMessage('Log out');
  }
}
