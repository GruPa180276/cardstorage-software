import 'package:flutter/material.dart';
import 'package:card_master/client/domain/enums/cardpage_type.dart';
import 'package:card_master/client/pages/widgets/visualize/cards_visualize.dart';

class CardPage extends StatefulWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  State<CardPage> createState() => _CardPage();
}

class _CardPage extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
    return ApiVisualizer(site: CardPageTypes.Karten);
  }
}
