import 'package:flutter/material.dart';
import 'package:rfidapp/provider/types/cards.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:rfidapp/config/palette.dart';
import 'package:intl/intl.dart';

class ListCards {
  static late var listOfTypes;
  static DateTime date = DateTime(2000, 1, 12, 12);
  static BuildContext? buildContext;
  static DateTime? vonTime;
  static DateTime? bisTime;
  static TextEditingController vonTextEdidtingcontroller =
      TextEditingController();
  static TextEditingController bisTextEdidtingcontroller =
      TextEditingController();

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
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(Icons.card_giftcard_sharp, size: 30),
                ),
                Column(
                  children: [
                    title,
                    Row(
                      children: [
                        ButtonBar(
                          children: [
                            FlatButton(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              shape: Border(
                                  top: BorderSide(
                                      color: ColorSelect.greyBorderColor),
                                  right: BorderSide(
                                      color: ColorSelect.greyBorderColor)),
                              color: Colors.transparent,
                              splashColor: Colors.black,
                              onPressed: _displayTextInputDialog,
                              child: Text('Reservieren',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor)),
                            ),
                            FlatButton(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                // NEW,
                                shape: Border(
                                    top: BorderSide(
                                        color: ColorSelect.greyBorderColor)),
                                //TODO ask if card is available and then ask if current time is not between reservated time
                                onPressed: buildNfcScanner,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                      maxWidth: double.infinity),
                                  child: Text('Jetzt holen',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor)),
                                ))
                          ],
                        )
                        //TODO chahnge to buttonbar
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      });

  static Future<void> _displayTextInputDialog() async {
    return showDialog(
        context: buildContext!,
        builder: (context) {
          return AlertDialog(title: Text('Reservierung'), actions: [
            Column(
              children: [
                buildTimeChooseSection(
                    buildContext!, "Von:", vonTextEdidtingcontroller),
                SizedBox(height: 20),
                buildTimeChooseSection(
                    buildContext!, "Bis:", bisTextEdidtingcontroller),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () => print('tbc'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 15),
                      child: Container(
                        child: Text(
                          'Jetzt Reservieren',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ))
              ],
            )
          ]);
        });
  }

  static void buildDateTimePicker(
      String text, TextEditingController editingController) {
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
      editingController.text =
          DateFormat('yyyy-MM-dd hh:mm').format(date).toString();
    }, currentTime: DateTime.now(), locale: LocaleType.de);
  }

  static Widget buildTimeChooseSection(BuildContext context, String text,
      TextEditingController editingController) {
    return Row(children: [
      Container(
        width: 40,
        child: Text(text),
      ),
      // SizedBox(
      //   width: 15,
      // ),
      Container(
        height: 40,
        width: 200,
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: TextField(
                controller: editingController,
                readOnly: true,
                decoration: InputDecoration(
                  prefixText: 'prefix',
                  prefixStyle: TextStyle(color: Colors.transparent),
                ),
              ),
            ),
            IconButton(
                icon: Icon(Icons.date_range),
                onPressed: () {
                  buildDateTimePicker(text, editingController);
                }),
          ],
        ),
      )
    ]);
  }

  static Future<void> buildNfcScanner() async {
    return showDialog(
        context: buildContext!,
        builder: (context) {
          return AlertDialog(
              title: Text('Halten Sie Ihre Telefon auf den NFC-Scanner'));
        });
  }
}
