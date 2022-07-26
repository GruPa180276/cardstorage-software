import 'package:flutter/material.dart';

class AddStorage extends StatefulWidget {
  const AddStorage({Key? key}) : super(key: key);

  @override
  State<AddStorage> createState() => _AddStorageState();
}

class _AddStorageState extends State<AddStorage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Add Storage"),
          backgroundColor: Colors.blueGrey,
          actions: []),
      body: Container(
          child: Column(
        children: [],
      )),
    );
  }
}
