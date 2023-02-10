import 'package:card_master/admin/pages/widget/appbar.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Logs extends StatefulWidget {
  late List<String> messages;
  late Function handle;

  Logs({
    required this.messages,
    required this.handle,
    Key? key,
  }) : super(key: key);

  @override
  _MultiWebSocketsState createState() => _MultiWebSocketsState();
}

class _MultiWebSocketsState extends State<Logs> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: generateAppBar(context),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.messages.length,
                itemBuilder: (context, index) {
                  return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(widget.messages[index]),
                      ));
                },
              ),
            )
          ]),
        ));
  }
}
