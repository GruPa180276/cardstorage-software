import 'package:flutter/material.dart';

import 'package:card_master/admin/pages/widget/popupdialog.dart';
import 'package:card_master/admin/pages/widget/customsearchdelegate.dart';

Expanded generateButtonRound(BuildContext context, String buttonText,
    IconData buttonIcon, String route) {
  return Expanded(
    child: ElevatedButton.icon(
      onPressed: () {
        Navigator.of(context).pushNamed(route);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: Size(double.infinity, 60),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        foregroundColor: Theme.of(context).focusColor,
      ),
      icon: Icon(
        buttonIcon,
        size: 24.0,
      ),
      label: Text(
        buttonText,
        style: TextStyle(fontSize: 20),
      ),
    ),
  );
}

Expanded generateButtonRoundWithoutRoute(
    BuildContext context,
    String buttonText,
    IconData buttonIcon,
    List<String> searchvalues,
    Function()? onpressd) {
  return Expanded(
    child: ElevatedButton.icon(
      onPressed: onpressd,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        minimumSize: Size(double.infinity, 50),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        foregroundColor: Theme.of(context).focusColor,
      ),
      icon: Icon(
        buttonIcon,
        size: 24.0,
      ),
      label: Text(
        buttonText,
        style: TextStyle(fontSize: 20),
      ),
    ),
  );
}

Expanded generateButtonRectangle(
  BuildContext context,
  String buttonText,
  Function()? onpressd,
) {
  return Expanded(
    child: ElevatedButton(
      onPressed: onpressd,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        minimumSize: const Size(double.infinity, 60),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        foregroundColor: Theme.of(context).focusColor,
      ),
      child: Text(buttonText, style: TextStyle(fontSize: 20)),
    ),
  );
}

Expanded generateButtonWithDialog(
  BuildContext context,
  String buttonText,
  Function()? onpressed,
) {
  return Expanded(
    child: ElevatedButton(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        minimumSize: Size(double.infinity, 50),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        foregroundColor: Theme.of(context).focusColor,
      ),
      child: Text(buttonText, style: TextStyle(fontSize: 20)),
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
        child: Text(widget.buttonText, style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

Expanded generateSearchButton(BuildContext context, String buttonText,
    IconData buttonIcon, Function setID, List<String> searchValues) {
  return Expanded(
    child: ElevatedButton.icon(
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
      icon: Icon(
        buttonIcon,
        size: 24.0,
      ),
      label: Text(
        buttonText,
        style: TextStyle(fontSize: 20),
      ),
    ),
  );
}
