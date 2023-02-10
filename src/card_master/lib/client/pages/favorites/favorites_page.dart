import 'package:flutter/material.dart';
import 'package:card_master/client/domain/enums/cardpage_type.dart';
import 'package:card_master/client/pages/widgets/visualize/cards_visualize.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePage();
}

class _FavoritePage extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return ApiVisualizer(site: CardPageType.Favoriten);
  }
}
