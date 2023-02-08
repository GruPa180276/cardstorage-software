import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enums/snackbar_type.dart';

class SnackbarBuilder {
  static void build(SnackbarType snackbarType, BuildContext context,
      bool successful, dynamic content) {
    SnackBar snackBar;
    if (successful) {
      switch (snackbarType) {
        case SnackbarType.USER:
          snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Anmeldung erfolgreich!',
                message: '',
                contentType: ContentType.success,
              ));
          break;
        case SnackbarType.CARD:
          snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Karte wird heruntergelassen!',
                message: '',
                contentType: ContentType.success,
              ));
          break;
      }
    } else {
      snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Etwas ist schiefgelaufen!',
            message: (content == null)
                ? content.toString()
                : "Anmeldung nicht erfolgreich",

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.failure,
          ));
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
