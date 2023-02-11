import 'package:card_master/client/config/properties/screen.dart';
import 'package:card_master/client/provider/size/size_manager.dart';
import 'package:flutter/material.dart';
import 'package:card_master/client/domain/types/cardpage_type.dart';
import 'package:card_master/client/pages/widgets/visualize/cards_visualize.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePage();
}

class _FavoritePage extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    SizeManager().init(
        MediaQuery.of(context).size, Screen.getScreenOrientation(context));
    return ApiVisualizer(site: CardPageType.Favoriten);
  }
}
