import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput(
      {Key? key,
      required this.inputController,
      required this.label,
      required this.iconData,
      required this.validator,
      required this.obsecureText})
      : super(key: key);

  final TextEditingController inputController;
  final String label;
  final IconData iconData;
  final String? Function(String?)? validator;
  final bool obsecureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
