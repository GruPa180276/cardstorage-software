import 'package:flutter/material.dart';

CircularProgressIndicator generateProgressIndicator(BuildContext context) {
  return CircularProgressIndicator(
    backgroundColor: Theme.of(context).secondaryHeaderColor,
    valueColor: AlwaysStoppedAnimation(Theme.of(context).focusColor),
  );
}
