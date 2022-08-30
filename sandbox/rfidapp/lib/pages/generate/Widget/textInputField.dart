import 'package:flutter/material.dart';
import 'package:rfidapp/domain/validator.dart';

class TextInput extends StatelessWidget {
  const TextInput(
      {Key? key,
      required this.inputController,
      required this.label,
      required this.iconData,
      required this.validator})
      : super(key: key);

  final TextEditingController inputController;
  final String label;
  final IconData iconData;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: inputController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          prefixIcon: Icon(iconData),
          labelText: label),
      validator: validator,
    );
  }
}
