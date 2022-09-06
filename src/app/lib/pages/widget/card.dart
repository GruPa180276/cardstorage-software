import 'package:flutter/material.dart';

import 'package:app/pages/widget/data.dart';

class GenerateCards extends StatefulWidget {
  final int index;
  final List<Data> data;
  final IconData icon;
  final String route;
  final int argument;

  const GenerateCards.withoutArguments({
    Key? key,
    required this.index,
    required this.data,
    required this.icon,
    required this.route,
    this.argument = 0,
  }) : super(key: key);

  const GenerateCards.withArguments(
      {Key? key,
      required this.index,
      required this.data,
      required this.icon,
      required this.route,
      required this.argument})
      : super(key: key);

  @override
  State<GenerateCards> createState() => _GenerateCardsState();
}

class _GenerateCardsState extends State<GenerateCards> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 85,
        padding: EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: 0, top: 5, bottom: 5, right: 0),
        decoration: BoxDecoration(
            border: Border.all(
              width: 3,
              color: Theme.of(context).secondaryHeaderColor,
            ),
            borderRadius: BorderRadius.circular(15)),
        child: Stack(children: [
          Positioned(
              left: 100,
              child: Text(widget.data[widget.index].title,
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).primaryColor))),
          setStateOfCardStorage(widget.data[widget.index].title.toString()),
          setCardStorageIcon(widget.data[widget.index].title.toString()),
          Icon(widget.icon, size: 60, color: Theme.of(context).primaryColor)
        ]),
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed(widget.route, arguments: widget.argument);
      },
    );
  }

  Widget setStateOfCardStorage(String card) {
    // ignore: unused_local_variable
    String cardName = card;
    Widget cardState = Text("");
    String apiCall = "x"; // Only Test Values, will be changed to an API call
    if (apiCall == "x") {
      cardState = Text("Verfügbar",
          style:
              TextStyle(fontSize: 20, color: Theme.of(context).primaryColor));
    } else if (apiCall == "y") {
      cardState = Text("Nicht Verfügbar",
          style:
              TextStyle(fontSize: 20, color: Theme.of(context).primaryColor));
    }
    return Positioned(left: 140, top: 30, child: cardState);
  }

  Widget setCardStorageIcon(String card) {
    // ignore: unused_local_variable
    String cardName = card;
    IconData cardIcon = Icons.not_started;
    String apiCall = "x"; // Only Test Values, will be changed to an API call
    if (apiCall == "x") {
      cardIcon = Icons.check;
    } else if (apiCall == "y") {
      cardIcon = Icons.cancel_rounded;
    }
    return Positioned(
        left: 100,
        top: 30,
        child: Icon(cardIcon, color: Theme.of(context).primaryColor));
  }
}
