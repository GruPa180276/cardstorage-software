import 'package:flutter/material.dart';
import 'package:rfidapp/provider/types/cards.dart';

class BottomPopUpFilter extends StatefulWidget {
  const BottomPopUpFilter(
      {Key? key, required this.onPressStorage, required this.listOfTypes});
  final Function(Future<List<Cards>>) onPressStorage;
  final Future<List<Cards>> listOfTypes;

  @override
  State<BottomPopUpFilter> createState() => _BottomPopUpFilterState();
}

class _BottomPopUpFilterState extends State<BottomPopUpFilter> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
