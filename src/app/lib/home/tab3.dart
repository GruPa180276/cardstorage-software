import 'package:flutter/material.dart';

class Tab3 extends StatelessWidget {
  const Tab3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter a search term',
        ),
      ),
    );
  }
}