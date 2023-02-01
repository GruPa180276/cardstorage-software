import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enum/readercard_type.dart';
import 'package:rfidapp/pages/generate/api_data_visualize.dart';

class ReservatePage extends StatefulWidget {
  const ReservatePage({Key? key}) : super(key: key);

  @override
  State<ReservatePage> createState() => _ReservatePage();
}

class _ReservatePage extends State<ReservatePage> {
  void initState() {
    super.initState();
    // _conntectToMqtt();
  }

  // void _conntectToMqtt() async {
  //   await MQTTClientManager.connect();
  //   MQTTClientManager.subscribe(StorageProperties.getStorageId()!, context);
  // }

  @override
  Widget build(BuildContext context) {
    return ApiVisualizer(
      site: CardPageType.Reservierungen,
    );
  }
}
