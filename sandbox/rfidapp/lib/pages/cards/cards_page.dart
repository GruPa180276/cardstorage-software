import 'package:flutter/material.dart';
import 'package:rfidapp/provider/dataType/cards.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:rfidapp/provider/restApi/fetchData.dart';

class CardPage extends StatefulWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  State<CardPage> createState() => _CardPage();
}

class _CardPage extends State<CardPage> {
  Future<List<Cards>>? listOfUsers;

  @override
  void initState() {
    super.initState();
    listOfUsers = FetchData.getData("posts").then(
        (value) => jsonDecode(value.body).map<Cards>(Cards.fromJson).toList());
  }

  Future<List<Cards>> getData() async {
    http.Response response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/posts"), headers: {
      //"key":"value" for authen.
      "Accept": "application/json"
    });
    return jsonDecode(response.body).map<Cards>(Cards.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listbv'),
      ),
      body: Center(child: buildListCards(context)),
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
    return FutureBuilder<List<Cards>>(
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

  Widget buildUsers(List<Cards> users) => ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: ListTile(
            title: Text(user.title),
            subtitle: Text(user.userId.toString()),
          ),
        );
      });
}
