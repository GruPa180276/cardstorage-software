import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:rfidapp/provider/restApi/data.dart';
import 'package:rfidapp/provider/types/cards.dart';

void buildDateTimePicker(String text, TextEditingController editingController,
    BuildContext context) {
  DatePicker.showDateTimePicker(context,
      minTime: DateTime.now(),
      theme: DatePickerTheme(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          doneStyle: TextStyle(color: Theme.of(context).primaryColor),
          cancelStyle: TextStyle(color: Theme.of(context).primaryColor),
          itemStyle: TextStyle(color: Theme.of(context).primaryColor)),
      showTitleActions: true,
      onChanged: (date) {}, onConfirm: (date) {
    editingController.text =
        DateFormat('yyyy-MM-dd hh:mm').format(date).toString();
  }, currentTime: DateTime.now(), locale: LocaleType.de);
}
