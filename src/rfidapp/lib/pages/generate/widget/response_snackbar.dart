import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enums/snackbar_type.dart';

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
              message: (content == null) ? '' : content!,
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
              message: (content == null) ? '' : content!,
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
              message: (content == null) ? '' : content!,
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
              message: (content == null) ? '' : content!,
              contentType: ContentType.help,
            ));
        break;
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
