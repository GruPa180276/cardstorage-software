import 'package:card_master/client/provider/size/size_extentions.dart';
import 'package:flutter/material.dart';

class ConnectionStatusTextfield extends StatelessWidget {
  final String text;

  const ConnectionStatusTextfield({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).dividerColor, fontSize: 3.0.fs),
        ),
      ),
    );
  }
}
