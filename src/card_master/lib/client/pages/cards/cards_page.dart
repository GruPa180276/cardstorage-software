import 'package:card_master/client/config/properties/screen.dart';
import 'package:card_master/client/provider/size/size_manager.dart';
import 'package:flutter/material.dart';
import 'package:card_master/client/domain/types/cardpage_type.dart';
import 'package:card_master/client/pages/widgets/wrapper/cards_wrapper.dart';

class CardPage extends StatefulWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  State<CardPage> createState() => _CardPage();
}

class _CardPage extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
    SizeManager().init(
        MediaQuery.of(context).size, Screen.getScreenOrientation(context));
    return ApiVisualizer(site: CardPageType.Karten);
  }
}
