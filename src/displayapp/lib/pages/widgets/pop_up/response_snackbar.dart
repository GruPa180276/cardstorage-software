import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enum/snackbar_type.dart';
import 'package:rfidapp/pages/widgets/pop_up/awesome_snackbar.dart/awesome_snackbar_content.dart';
import 'package:rfidapp/pages/widgets/pop_up/awesome_snackbar.dart/content_type.dart';

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
              message: (content == null) ? '' : content!.toString(),
              contentType: ContentType.warning,
            ));
        break;
      case SnackbarType.failure:
        snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            margin: const EdgeInsets.symmetric(horizontal: 0),
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
