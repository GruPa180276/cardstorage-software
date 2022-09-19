import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/popupdialog.dart';
import 'package:admin_login/pages/widget/customsearchdelegate.dart';

Expanded generateButtonRound(BuildContext context, String buttonText,
    IconData buttonIcon, String route) {
  return Expanded(
    child: ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(route);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        minimumSize: Size(double.infinity, 50),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        foregroundColor: Theme.of(context).focusColor,
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

Expanded generateButtonRoundWithoutRoute(
    BuildContext context, String buttonText, IconData buttonIcon) {
  return Expanded(
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        minimumSize: Size(double.infinity, 50),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        foregroundColor: Theme.of(context).focusColor,
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

Expanded generateButtonRectangle(BuildContext context, String buttonText) {
  return Expanded(
    child: ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        minimumSize: Size(double.infinity, 50),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        foregroundColor: Theme.of(context).focusColor,
      ),
      child: Wrap(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Text(buttonText, style: TextStyle(fontSize: 20)),
        ],
      ),
    ),
  );
}

Expanded generateButtonWithDialog(BuildContext context, String buttonText) {
  return Expanded(
    child: ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => generatePopupDialog(context),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        minimumSize: Size(double.infinity, 50),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        foregroundColor: Theme.of(context).focusColor,
      ),
      child: Wrap(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Text(buttonText, style: TextStyle(fontSize: 20)),
        ],
      ),
    ),
  );
}

class GenerateButtonWithDialogAndCallBack extends StatefulWidget {
  final String buttonText;
  final Function function;

  const GenerateButtonWithDialogAndCallBack({
    Key? key,
    required this.buttonText,
    required this.function,
  }) : super(key: key);

  @override
  State<GenerateButtonWithDialogAndCallBack> createState() =>
      _GenerateButtonWithDialogAndCallBackState();
}

class _GenerateButtonWithDialogAndCallBackState
    extends State<GenerateButtonWithDialogAndCallBack> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => generatePopupDialog(context),
          );
          widget.function("Temp HW ID");
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          minimumSize: Size(double.infinity, 50),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          foregroundColor: Theme.of(context).focusColor,
        ),
        child: Wrap(
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Text(widget.buttonText, style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

Expanded generateSearchButton(BuildContext context, String buttonText,
    IconData buttonIcon, Function setID, List<String> searchValues) {
  return Expanded(
    child: ElevatedButton(
      onPressed: () {
        showSearch(
            context: context,
            delegate: CustomSearchDelegate(setID, searchValues));
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        minimumSize: Size(double.infinity, 50),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        foregroundColor: Theme.of(context).focusColor,
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