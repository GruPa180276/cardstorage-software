// ignore_for_file: must_be_immutable

import 'package:card_master/client/provider/size/size_extentions.dart';
import 'package:flutter/material.dart';
import 'package:card_master/client/pages/widgets/utils/AlwaysDisabledFocusNode.dart';

class TextInput extends StatelessWidget {
  TextInput(
      {Key? key,
      required this.inputController,
      required this.label,
      required this.iconData,
      required this.validator,
      required this.obsecureText,
      this.editable})
      : super(key: key);

  final TextEditingController inputController;
  final String label;
  final IconData iconData;
  final String? Function(String?)? validator;
  final bool obsecureText;
  bool? editable;
  @override
  Widget build(BuildContext context) {
    AlwaysDisabledFocusNode? temp;
    editable = editable ?? true;
    if (!editable!) {
      temp = AlwaysDisabledFocusNode();
    }

    return TextFormField(
      enableInteractiveSelection:
          editable ?? true, // will disable paste operation
      focusNode: temp,
      controller: inputController,
      style: TextStyle(fontSize: 2.0.fs),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelStyle: TextStyle(fontSize: 2.0.fs),
          border: const UnderlineInputBorder(),
          prefixIcon: Icon(iconData),
          labelText: label),
      obscureText: obsecureText,
      validator: validator,
    );
  }
}
