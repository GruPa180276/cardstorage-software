import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enums/cardpage_type.dart';
import 'package:rfidapp/pages/widgets/visualize/reservate_visualize.dart';

class ReservatePage extends StatefulWidget {
  const ReservatePage({Key? key}) : super(key: key);

  @override
  State<ReservatePage> createState() => _ReservatePage();
}

class _ReservatePage extends State<ReservatePage> {
  @override
  Widget build(BuildContext context) {
    return ReservationVisualizer(
      site: CardPageTypes.Reservierungen,
    );
  }
}
