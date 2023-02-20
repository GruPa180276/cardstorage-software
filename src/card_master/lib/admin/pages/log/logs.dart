import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/widget/appbar.dart';
import 'package:card_master/admin/pages/navigation/websockets.dart';

class Logs extends StatefulWidget {
  const Logs({
    Key? key,
  }) : super(key: key);

  @override
  MultiWebSocketsState createState() => MultiWebSocketsState();
}

class MultiWebSocketsState extends State<Logs> {
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    messages = Websockets.getMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: generateAppBar(context),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(messages[index]),
                      ));
                },
              ),
            )
          ]),
        ));
  }
}
