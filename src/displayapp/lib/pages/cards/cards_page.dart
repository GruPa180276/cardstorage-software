import 'package:flutter/material.dart';
import 'package:rfidapp/pages/generate/api_data_visualize.dart';
import 'package:rfidapp/provider/mqtt/mqtt.dart';

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
    _conntectToMqtt();
  }

  void _conntectToMqtt() async {
    await MQTTClientManager.connect();
    MQTTClientManager.subscribe("topic", context);
  }

  @override
  Widget build(BuildContext context) {
    return ApiVisualizer(site: 'Karten');
  }
}
