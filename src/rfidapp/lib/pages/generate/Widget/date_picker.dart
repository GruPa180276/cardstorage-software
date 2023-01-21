import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

void buildDateTimePicker(
    TextEditingController editingController, BuildContext context) {
  DatePicker.showDateTimePicker(context,
      minTime: DateTime.now().add(const Duration(hours: 0)),
      theme: DatePickerTheme(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          doneStyle: TextStyle(color: Theme.of(context).primaryColor),
          cancelStyle: TextStyle(color: Theme.of(context).primaryColor),
          itemStyle: TextStyle(color: Theme.of(context).primaryColor)),
      showTitleActions: true,
      onChanged: (date) {}, onConfirm: (date) {
    editingController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(date).toString();
  },
      currentTime: DateTime.now().add(const Duration(hours: 0)),
      locale: LocaleType.de);
}
