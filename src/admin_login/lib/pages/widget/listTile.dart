import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

class GenerateListTile extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData icon;
  final String regExp;
  final Function function;
  final bool state;

  const GenerateListTile({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.icon,
    required this.regExp,
    required this.function,
    required this.state,
  }) : super(key: key);

  @override
  State<GenerateListTile> createState() => _GenerateListTileState();
}

class _GenerateListTileState extends State<GenerateListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.icon, color: Theme.of(context).primaryColor),
      title: TextField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(widget.regExp))
        ],
        enabled: widget.state,
        decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            )),
        onChanged: (value) => widget.function(value),
      ),
    );
  }
}
