import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class GenerateListTile extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData icon;
  final String regExp;
  final Function function;
  final TextEditingController controller;
  final String? Function(dynamic value) fun;

  const GenerateListTile({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.icon,
    required this.regExp,
    required this.function,
    required this.controller,
    required this.fun,
  }) : super(key: key);

  @override
  State<GenerateListTile> createState() => _GenerateListTileState();
}

class _GenerateListTileState extends State<GenerateListTile> {
  @override
  Widget build(BuildContext context) {
    return SizerUtil.deviceType == DeviceType.mobile
        ? ListTile(
            leading: Icon(
              widget.icon,
              color: Theme.of(context).primaryColor,
              size: 4.h,
            ),
            title: TextFormField(
              style: TextStyle(
                fontSize: 12.sp,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(widget.regExp))
              ],
              controller: widget.controller,
              validator: widget.fun,
              decoration: InputDecoration(
                  labelText: widget.labelText,
                  hintText: widget.hintText,
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  )),
              onChanged: (value) => widget.function(value),
            ),
          )
        : ListTile(
            leading: Icon(
              widget.icon,
              color: Theme.of(context).primaryColor,
              size: 5.h,
            ),
            title: TextFormField(
              style: TextStyle(
                fontSize: 9.sp,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(widget.regExp))
              ],
              controller: widget.controller,
              validator: widget.fun,
              decoration: InputDecoration(
                  labelText: widget.labelText,
                  hintText: widget.hintText,
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  )),
              onChanged: (value) => widget.function(value),
            ),
          );
  }
}
