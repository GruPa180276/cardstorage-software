import 'package:flutter/material.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:rfidapp/config/palette.dart';

class ListCards {
  static late var listOfTypes;
  static DateTime date = DateTime(2000, 1, 12, 12);
  static BuildContext? buildContext;
  //@TODO and voidCallback
  static Widget buildListCards(BuildContext context) {
    buildContext = context;
    return FutureBuilder<List<Cards>>(
      future: listOfTypes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final users = snapshot.data!;
          return buildUsers(users);
        } else {
          return Text("${snapshot.error}");
        }
      },
    );
  }

  static Widget buildUsers(List<Cards> users) => ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        Text title = Text(user.userId.toString());

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Icon(Icons.card_giftcard_sharp, size: 30),
              ),
              Container(
                child: Column(
                  children: [
                    title,
                    Row(
                      children: [
                        FlatButton(
                            padding: EdgeInsets.symmetric(horizontal: 35),
                            shape: Border(
                                top: BorderSide(
                                    color: ColorSelect.greyBorderColor),
                                right: BorderSide(
                                    color: ColorSelect.greyBorderColor)),
                            color: Colors.transparent,
                            splashColor: Colors.black,
                            onPressed: buildReservatePopUp,
                            child: Text('Reservieren')),
                        FlatButton(
                            padding: EdgeInsets.symmetric(horizontal: 35),
                            color: Colors.transparent,
                            shape: Border(
                                top: BorderSide(
                                    color: ColorSelect.greyBorderColor)),
                            //TODO ask if card is available and then ask if current time is not between reservated time
                            onPressed: buildDateTimePicker,
                            child: Text('Jetzt holen'))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      });

  static void buildReservatePopUp() {
    showDialog(
      context: buildContext!,
      builder: (ctx) => AlertDialog(
        title: const Text("Reservierung"),
        content: Column(
          children: [
            Row(
              children: [
                const Text("Von"),
                ElevatedButton(
                    onPressed: buildDateTimePicker,
                    child: Icon(Icons.date_range))
              ],
            )
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              color: Colors.green,
              padding: const EdgeInsets.all(14),
              child: const Text("okay"),
            ),
          ),
        ],
      ),
    );
  }

  static void buildDateTimePicker() {
    DatePicker.showDateTimePicker(buildContext!,
        minTime: DateTime.now(),
        theme: DatePickerTheme(
            backgroundColor: Theme.of(buildContext!).scaffoldBackgroundColor,
            doneStyle: TextStyle(color: Theme.of(buildContext!).primaryColor),
            cancelStyle: TextStyle(color: Theme.of(buildContext!).primaryColor),
            itemStyle: TextStyle(color: Theme.of(buildContext!).primaryColor)),
        showTitleActions: true, onChanged: (date) {
      print('change $date');
    }, onConfirm: (date) {
      print('confirm $date');
    }, currentTime: DateTime.now(), locale: LocaleType.de);
  }
}
