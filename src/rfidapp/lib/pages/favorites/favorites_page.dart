import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enums/cardsSiteEnum.dart';
import 'package:rfidapp/pages/generate/api_data_visualize.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePage();
}

class _FavoritePage extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return ApiVisualizer(site: CardPageTypes.Favoriten );
  }
}
