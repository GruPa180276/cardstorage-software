import 'package:admin_login/pages/widget/createCard.dart';
import 'package:admin_login/pages/widget/createStatus.dart';
import 'package:admin_login/pages/widget/createStorage.dart';
import 'package:admin_login/provider/types/focus.dart';
import 'package:admin_login/provider/types/ping.dart';
import 'package:admin_login/provider/types/storages.dart';
import 'package:flutter/material.dart';

class GenerateCardWithInkWell extends StatefulWidget {
  final int index;
  final List<dynamic>? data;
  final IconData icon;
  final String route;
  final String argument;
  final int view;

  const GenerateCardWithInkWell.withoutArguments({
    Key? key,
    required this.index,
    required this.data,
    required this.icon,
    required this.route,
    required this.view,
    this.argument = "",
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
  late Ping ping;
  late Storages storage;
  int count = 0;
  bool pingWorked = false;
  bool focus = true;
  late List<FocusS> listOfStorages;

  @override
  void initState() {
    super.initState();
    pingNow();
    getNumberOfCardsInStorage();
    checkFocus();
  }

  void pingNow() async {
    await pingStorage(widget.data![widget.index].name)
        .then((value) => ping = value);

    if (ping.time != 0) {
      pingWorked = true;
    }
  }

  void getNumberOfCardsInStorage() async {
    await getAllCardsPerStorage(widget.data![widget.index].name)
        .then((value) => storage = value);

    count = 0;

    setState(() {
      for (int i = 0; i < storage.cards.length; i++) {
        if (storage.cards[i].available == true) {
          count++;
        }
      }
    });
  }

  void checkFocus() async {
    await getAllUnfocusedStorages().then((value) => listOfStorages = value);

    for (int i = 0; i < listOfStorages.length; i++) {
      if (listOfStorages[i].name == widget.argument) {
        focus = false;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              child: Container(
                  padding: EdgeInsets.all(15),
                  child: Row(children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 0,
                        right: 15,
                      ),
                      child: Icon(widget.icon, size: 50),
                    ),
                    Expanded(child: setStateOfCardStorage(context)),
                  ])),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(widget.route, arguments: widget.argument);
              },
            )));
  }

  Widget setStateOfCardStorage(BuildContext context) {
    if (widget.view == 1) {
      return createCardTable(
        context,
        widget.data![widget.index].name,
        widget.data![widget.index].accessed,
        widget.data![widget.index].available,
      );
    }
    if (widget.view == 2) {
      return createStatus(
        context,
        pingWorked,
        widget.data![widget.index].name,
        count,
        widget.data![widget.index].numberOfCards,
      );
    }
    if (widget.view == 3) {
      return createStorageTable(
        context,
        widget.data![widget.index].name,
        widget.data![widget.index].location,
        widget.data![widget.index].numberOfCards,
        focus,
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
