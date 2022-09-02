import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// ignore: must_be_immutable
class GenerateSpeedDial extends StatelessWidget {
  late Function callBack;

  GenerateSpeedDial(Function state) {
    callBack = state;
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 28.0),
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      foregroundColor: Theme.of(context).focusColor,
      visible: true,
      curve: Curves.bounceInOut,
      children: [
        SpeedDialChild(
          child: Icon(Icons.storage, color: Theme.of(context).focusColor),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          onTap: () => callBack("1"),
          label: '1',
          labelStyle: TextStyle(
              fontWeight: FontWeight.w500, color: Theme.of(context).focusColor),
          labelBackgroundColor: Theme.of(context).secondaryHeaderColor,
        ),
        SpeedDialChild(
          child: Icon(Icons.storage, color: Theme.of(context).focusColor),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          onTap: () => callBack("2"),
          label: '2',
          labelStyle: TextStyle(
              fontWeight: FontWeight.w500, color: Theme.of(context).focusColor),
          labelBackgroundColor: Theme.of(context).secondaryHeaderColor,
        ),
        SpeedDialChild(
          child: Icon(Icons.storage, color: Theme.of(context).focusColor),
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          onTap: () => callBack("3"),
          label: '3',
          labelStyle: TextStyle(
              fontWeight: FontWeight.w500, color: Theme.of(context).focusColor),
          labelBackgroundColor: Theme.of(context).secondaryHeaderColor,
        ),
      ],
    );
  }
}
