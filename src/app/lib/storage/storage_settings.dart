import 'package:flutter/material.dart';

class StorageSettings extends StatefulWidget {
  const StorageSettings({Key? key}) : super(key: key);

  @override
  State<StorageSettings> createState() => _StorageSettingsState();
}

class _StorageSettingsState extends State<StorageSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Storage Settings"),
          backgroundColor: Colors.blueGrey,
          actions: []),
      body: Container(
          child: Column(
        children: [],
      )),
    );
  }
}
