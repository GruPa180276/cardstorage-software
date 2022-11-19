import 'package:admin_login/pages/widget/createCard.dart';
import 'package:admin_login/pages/widget/createStorage.dart';
import 'package:admin_login/pages/widget/createUser.dart';
import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/data.dart';

class GenerateCardWithInkWell extends StatefulWidget {
  final int index;
  final List<Data>? data;
  final IconData icon;
  final String route;
  final int argument;
  final int view;

  const GenerateCardWithInkWell.withoutArguments({
    Key? key,
    required this.index,
    required this.data,
    required this.icon,
    required this.route,
    required this.view,
    this.argument = 0,
  }) : super(key: key);

  const GenerateCardWithInkWell.withArguments(
      {Key? key,
      required this.index,
      required this.data,
      required this.icon,
      required this.route,
      required this.view,
      required this.argument})
      : super(key: key);

  @override
  State<GenerateCardWithInkWell> createState() =>
      _GenerateCardWithInkWellState();
}

class _GenerateCardWithInkWellState extends State<GenerateCardWithInkWell> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          child: Container(
              padding: EdgeInsets.all(10),
              child: Row(children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 25,
                  ),
                  child: Icon(widget.icon, size: 50),
                ),
                setStateOfCardStorage(context),
              ])),
          onTap: () {
            Navigator.of(context)
                .pushNamed(widget.route, arguments: widget.index);
          },
        ));
  }

  Widget setStateOfCardStorage(BuildContext context) {
    if (widget.view == 1) {
      return createCardTable(
          context,
          widget.data![widget.index].id,
          widget.data![widget.index].title.toString(),
          widget.data![widget.index].id,
          false);
    }
    if (widget.view == 2) {
      return createUserTable(
        context,
        widget.data![widget.index].id,
        widget.data![widget.index].title.toString(),
        widget.data![widget.index].title.toString(),
      );
    }
    if (widget.view == 3) {
      return createStorageTable(
        context,
        widget.data![widget.index].id,
        widget.data![widget.index].title.toString(),
        widget.data![widget.index].id,
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
