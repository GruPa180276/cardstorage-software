import 'package:card_master/client/pages/widgets/pop_up/snackbar/awesome_snackbar_content.dart';
import 'package:card_master/client/pages/widgets/pop_up/snackbar/content_type.dart';
import 'package:flutter/material.dart';
import 'package:card_master/client/domain/types/snackbar_type.dart';

class SnackbarBuilder {
  final SnackbarType snackbarType;
  final BuildContext context;
  final String header;
  dynamic content;

  SnackbarBuilder(
      {required this.snackbarType,
      required this.context,
      required this.header,
      this.content});

  void build() {
    SnackBar? snackBar;
    switch (snackbarType) {
      case SnackbarType.success:
        snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: header,
              message: (content == null) ? '' : content.toString(),
              contentType: ContentType.success,
            ));
        break;
      case SnackbarType.warning:
        snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: header,
              message: (content == null) ? '' : content.toString(),
              contentType: ContentType.warning,
            ));
        break;
      case SnackbarType.failure:
        snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: header,
              message: (content == null) ? '' : content.toString(),
              contentType: ContentType.failure,
            ));
        break;
      case SnackbarType.help:
        snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: header,
              message: (content == null) ? '' : content.toString(),
              contentType: ContentType.help,
            ));
        break;
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
