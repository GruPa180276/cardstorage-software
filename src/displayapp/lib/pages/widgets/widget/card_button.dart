import 'package:flutter/material.dart';
import 'package:rfidapp/provider/size/size_extentions.dart';

class CardButton extends StatelessWidget {
  final String text;
  final void Function()? onPress;

  const CardButton({
    super.key,
    required this.text,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Container(
        height: 5.4.hs,
        child: TextButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.black.withOpacity(0)), // <-- Does not work
          onPressed: onPress,
          child: Text(text,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 1.75.fs)),
        ),
      ),
    );
  }
}
