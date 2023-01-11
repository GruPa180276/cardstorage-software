import 'package:flutter/material.dart';
import 'package:rfidapp/domain/enum/readercard_type.dart';
import 'package:rfidapp/pages/generate/api_data_visualize.dart';

class CardPage extends StatefulWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  State<CardPage> createState() => _CardPage();
}

class _CardPage extends State<CardPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _conntectToMqtt();
  }

  // void _conntectToMqtt() async {
  //   await MQTTClientManager.connect();
  //   //@TODO change topic to storageid@location
  //   //you can find both at your config file
  //   print(StorageProperties.getStorageId()!);
  //   MQTTClientManager.subscribe(StorageProperties.getStorageId()!, context);
  // }

  @override
  Widget build(BuildContext context) {
    return ApiVisualizer(site: CardPageType.Karten);
  }
}
