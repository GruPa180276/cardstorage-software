import 'package:card_master/client/provider/size/size_extentions.dart';
import 'package:flutter/material.dart';

class DefaultCustomButton extends StatelessWidget {
  final Color bgColor;
  final Color borderColor;
  final Color textColor;
  final String text;
  final void Function()? onPress;

  const DefaultCustomButton(
      {super.key,
      required this.bgColor,
      required this.borderColor,
      required this.text,
      required this.onPress,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(bgColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                  side: BorderSide(color: borderColor, width: 2.2)))),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 2.5.fs,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
