import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GenerateReloadButton extends StatelessWidget {
  late Function callBack;

  GenerateReloadButton(Function state) {
    callBack = state;
  }

  @override
  Stack build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              foregroundColor: Theme.of(context).focusColor,
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              onPressed: () {
                callBack();
              },
              child: Icon(
                Icons.refresh,
                color: Theme.of(context).focusColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
