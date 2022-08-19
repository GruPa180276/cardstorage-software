import 'package:flutter/material.dart';
import 'package:rfidapp/provider/types/cards.dart';

class ListCards {
  static late var listOfTypes;

  //@TODO and voidCallback
  static Widget buildListCards(BuildContext context) {
    return FutureBuilder<List<Cards>>(
      future: listOfTypes,
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
