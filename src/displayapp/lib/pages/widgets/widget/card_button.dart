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
        ),
      ),
      child: Container(
        height: (MediaQuery.of(context).orientation == Orientation.portrait)
            ? MediaQuery.of(context).size.width / 9
            : MediaQuery.of(context).size.height / 10,
        child: TextButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.black.withOpacity(0)), // <-- Does not work
          onPressed: onPress,
          child: Text(text,
              style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ),
    );
  }
}
