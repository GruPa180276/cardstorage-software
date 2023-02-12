import 'package:card_master/client/provider/size/size_extentions.dart';
import 'package:flutter/material.dart';

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
          right: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: TextButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black.withOpacity(0)), // <-- Does not work
        onPressed: onPress,
        child: Container(
          child: Text(text,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 2.3.fs)),
        ),
      ),
    );
  }
}
