import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enum/readercard_type.dart';
import 'package:rfidapp/pages/widgets/api_data_visualize.dart';

class ReservatePage extends StatefulWidget {
  const ReservatePage({Key? key}) : super(key: key);

  @override
  State<ReservatePage> createState() => _ReservatePage();
}

class _ReservatePage extends State<ReservatePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ApiVisualizer(
      site: CardPageType.Reservierungen,
    );
  }
}
