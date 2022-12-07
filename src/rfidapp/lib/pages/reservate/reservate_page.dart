import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enums/cardsSiteEnum.dart';
import 'package:rfidapp/pages/generate/api_data_visualize.dart';

class ReservatePage extends StatefulWidget {
  const ReservatePage({Key? key}) : super(key: key);

  @override
  State<ReservatePage> createState() => _ReservatePage();
}

class _ReservatePage extends State<ReservatePage> {
  @override
  Widget build(BuildContext context) {
    return ApiVisualizer(
      site: CardPageTypes.Reservierungen,
    );
  }
}
