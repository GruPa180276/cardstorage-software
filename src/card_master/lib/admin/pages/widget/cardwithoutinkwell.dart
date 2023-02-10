import 'package:flutter/material.dart';

class GenerateCardWithoutInkWell extends StatefulWidget {
  final IconData icon;
  final String name;
  final Function() onpressd;

  const GenerateCardWithoutInkWell(
      {Key? key,
      required this.icon,
      required this.name,
      required this.onpressd})
      : super(key: key);

  @override
  State<GenerateCardWithoutInkWell> createState() =>
      _GenerateCardWithoutInkWellState();
}

class _GenerateCardWithoutInkWellState
    extends State<GenerateCardWithoutInkWell> {
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
                height: 85,
                padding: EdgeInsets.all(10),
                child: Stack(children: [
                  Positioned(
                      left: 100,
                      top: 15,
                      child: Text(widget.name,
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor))),
                  Icon(widget.icon,
                      size: 60, color: Theme.of(context).primaryColor)
                ]),
              ),
              onTap: widget.onpressd,
            )));
  }
}
