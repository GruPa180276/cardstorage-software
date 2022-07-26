import 'package:flutter/material.dart';
import '../color/color.dart';
import '../textValues/textValues.dart';

Tab2ColorProvider tab2CP = new Tab2ColorProvider();
Tab2DescrpitionProvider tab2DP = new Tab2DescrpitionProvider();

class Tab2 extends StatelessWidget {
  const Tab2({Key? key}) : super(key: key);

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
