// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/utils/AlwaysDisabledFocusNode.dart';

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
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          prefixIcon: Icon(iconData),
          labelText: label),
      obscureText: obsecureText,
      validator: validator,
    );
  }
}
