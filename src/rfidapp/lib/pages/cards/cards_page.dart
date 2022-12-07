import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enums/cardsSiteEnum.dart';
import 'package:rfidapp/pages/generate/api_data_visualize.dart';

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
