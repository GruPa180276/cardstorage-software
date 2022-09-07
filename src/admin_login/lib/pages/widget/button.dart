import 'package:flutter/material.dart';

Expanded generateButton(BuildContext context, String buttonText,
    IconData buttonIcon, String route) {
  return Expanded(
    child: ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(route);
      },
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        minimumSize: Size(double.infinity, 50),
      ),
      child: Wrap(
        children: <Widget>[
          Icon(
            buttonIcon,
          ),
          SizedBox(
            width: 10,
          ),
          Text(buttonText, style: TextStyle(fontSize: 20)),
        ],
      ),
    ),
  );
}

/*Expanded generateButton(BuildContext context, String buttonText,
    IconData buttonIcon, String route) {
  return Expanded(
    child: FloatingActionButton.extended(
      label: Text(buttonText),
      icon: Icon(buttonIcon),
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      foregroundColor: Theme.of(context).focusColor,
      onPressed: () {
        Navigator.of(context).pushNamed(route);
      },
    ),
  );
}
*/