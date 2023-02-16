import 'package:card_master/client/pages/widgets/pop_up/snackbar/awesome_snackbar_content.dart';
import 'package:card_master/client/pages/widgets/pop_up/snackbar/content_type.dart';
import 'package:flutter/material.dart';
import 'package:card_master/client/domain/types/snackbar_type.dart';

class FeedbackBuilder {
  final FeedbackType snackbarType;
  final BuildContext context;
  final String header;
  dynamic content;

  FeedbackBuilder(
      {required this.snackbarType,
      required this.context,
      required this.header,
      this.content});

  void build() {
    SnackBar? snackBar;
    switch (snackbarType) {
      case FeedbackType.success:
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
      case FeedbackType.warning:
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
      case FeedbackType.failure:
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
      case FeedbackType.help:
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
