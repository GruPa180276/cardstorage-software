import 'package:flutter/material.dart';
import 'package:card_master/client/domain/enums/cardpage_type.dart';
import 'package:card_master/client/pages/widgets/visualize/reservate_visualize.dart';

class ReservatePage extends StatefulWidget {
  const ReservatePage({Key? key}) : super(key: key);

  @override
  State<ReservatePage> createState() => _ReservatePage();
}

class _ReservatePage extends State<ReservatePage> {
  @override
  Widget build(BuildContext context) {
    return ReservationVisualizer(
      site: CardPageType.Reservierungen,
    );
  }
}
