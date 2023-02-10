import 'package:flutter/material.dart';

class ConnectionStatusTextfield extends StatelessWidget {
  final String text;

  const ConnectionStatusTextfield({required this.text});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Theme.of(context).dividerColor, fontSize: 20),
        ),
      ),
    );
  }
}
