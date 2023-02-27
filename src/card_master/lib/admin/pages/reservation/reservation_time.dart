import 'package:card_master/admin/pages/card/alert_dialog.dart';
import 'package:card_master/admin/pages/widget/button.dart';
import 'package:card_master/admin/pages/widget/list_tile.dart';
import 'package:card_master/admin/provider/middelware.dart';
import 'package:card_master/admin/provider/types/time.dart';
import 'package:card_master/client/domain/types/snackbar_type.dart';
import 'package:card_master/client/pages/widgets/pop_up/feedback_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ListReservationTime extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;

  const ListReservationTime({
    Key? key,
    required this.formKey,
    required this.nameController,
  }) : super(key: key);

  @override
  State<ListReservationTime> createState() => _ListReservationTimeState();
}

class _ListReservationTimeState extends State<ListReservationTime> {
  double time = 0;

  void setTime(String time) {
    this.time = double.parse(time);
  }

  @override
  Widget build(BuildContext context) {
    Response? response1;

    return Form(
      key: widget.formKey,
      child: Column(children: [
        GenerateListTile(
          labelText: "Zeit",
          hintText: "",
          icon: Icons.storage,
          regExp: r'([0-9\. ])',
          function: setTime,
          controller: widget.nameController,
          fun: (value) {
            if (value!.isEmpty) {
              return 'Bitte Zeit eingeben!';
            } else {
              return null;
            }
          },
        ),
        const SizedBox(
          height: 10,
        ),
        generateButtonRectangle(
          context,
          "Speichern",
          () {
            showDialog(
                context: context,
                builder: (BuildContext context) => buildAlertDialog(
                      context,
                      "Reservierung Einstellungen ...",
                      "Wollen Sie die Zeit ändern? ",
                      [
                        generateButtonRectangle(context, "Ja", () async {
                          if (widget.formKey.currentState!.validate()) {
                            response1 = await Data.checkAuthorization(
                              function: changeReservationLatestGetTime,
                              context: context,
                              args: {
                                'data': time.toString(),
                              },
                            );

                            if (response1!.statusCode == 200 &&
                                context.mounted) {
                              FeedbackBuilder(
                                context: context,
                                header: "Erfolgreich",
                                snackbarType: FeedbackType.success,
                                content: "Zeit wurde geändert!",
                              ).build();
                            }

                            if (context.mounted) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                          }
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        generateButtonRectangle(
                          context,
                          "Nein",
                          () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ));
          },
        ),
      ]),
    );
  }
}
