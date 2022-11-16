import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';

class EmailPopUp {
  static void show(
      BuildContext context, String to, String subject, String body) async {
    var result = await OpenMailApp.composeNewEmailInMailApp(
      emailContent: EmailContent(
          cc: List.filled(1, "grubauer.patrick@gmail.com"),
          body: body,
          bcc: List.filled(1, "grubauer.patrick@gmail.com"),
          to: List.filled(1, to),
          subject: subject),
    );

    // If no mail apps found, show error
    if (!result.didOpen && !result.canOpen) {
      _showNoMailAppsDialog(context);

      // iOS: if multiple mail apps found, show dialog to select.
      // There is no native intent/default app system in iOS so
      // you have to do it yourself.
    } else if (!result.didOpen && result.canOpen) {
      showDialog(
        context: context,
        builder: (_) {
          return MailAppPickerDialog(
            mailApps: result.options,
          );
        },
      );
    }
  }

  static void _showNoMailAppsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Open Mail App"),
            content: Text("No mail apps installed"),
            actions: <Widget>[
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
