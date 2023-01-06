import 'package:flutter/material.dart';
import 'package:rfidapp/config/cardSiteEnum.dart';
import 'package:rfidapp/pages/generate/api_data_visualize.dart';
import 'package:rfidapp/provider/mqtt/mqtt.dart';
import 'package:rfidapp/domain/storage_properties.dart';

class ReservatePage extends StatefulWidget {
  const ReservatePage({Key? key}) : super(key: key);

  @override
  State<ReservatePage> createState() => _ReservatePage();
}

class _ReservatePage extends State<ReservatePage> {
  void initState() {
    // TODO: implement initState
    super.initState();
    _conntectToMqtt();
  }

  void _conntectToMqtt() async {
    await MQTTClientManager.connect();
    MQTTClientManager.subscribe(StorageProperties.getStorageId()!, context);
  }

  @override
  Widget build(BuildContext context) {
    return ApiVisualizer(
      site: CardPageType.Reservierungen,
    );
  }
}
