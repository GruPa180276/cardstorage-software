// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:rfidapp/provider/card_repository/cards.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(new MaterialApp(home: new Homepage()));
}

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<List<User>> listOfUsers;

  @override
  void initState() {
    super.initState();
    listOfUsers = getData();
  }

  Future<List<User>> getData() async {
    http.Response response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/posts"), headers: {
      //"key":"value" for authen.
      "Accept": "application/json"
    });
    print('hellsaasdo');
    return jsonDecode(response.body).map<User>(User.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Listbv'),
      ),
      body: new Center(child: buildListCards(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          setState(() {
            listOfUsers = getData();
          })
        },
      ),
    );
  }

  Widget buildListCards(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: listOfUsers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final users = snapshot.data!;
          return buildUsers(users);
        } else {
          return Text("${snapshot.error}");
        }
      },
    );
  }

  Widget buildUsers(List<User> users) => ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          elevation: 3,
          child: ListTile(
            title: Text(user.title),
            subtitle: Text(user.userId.toString()),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
        );
      });
}
