import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';

class EmailPopUp {
  final BuildContext context;
  final String to;
  final String subject;
  final String body;

  EmailPopUp(
      {required this.context,
      required this.to,
      required this.subject,
      required this.body});

  void show() async {
    var result = await OpenMailApp.composeNewEmailInMailApp(
      emailContent:
          EmailContent(body: body, to: List.filled(1, to), subject: subject),
    );

    // If no mail apps found, show error
    if (!result.didOpen && !result.canOpen) {
      _showNoMailAppsDialog(context);
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
            title: const Text("Open Mail App"),
            content: const Text("No mail apps installed"),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
