import 'package:flutter/material.dart';

import 'package:async/async.dart';
import 'package:admin_login/pages/widget/appbar.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:admin_login/config/theme/app_preference.dart';

class Logs extends StatefulWidget {
  const Logs({Key? key}) : super(key: key);

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  late bool isDark;
  late Stream streamControler;
  late Stream streamCard;
  late Stream streamStorage;
  late Stream streamUser;
  late Stream streamReservation;
  late Stream websocketData;

  final channelControler = WebSocketChannel.connect(
      Uri.parse('wss://192.168.0.173:7171/api/controller/log'));
  final channelCard =
      WebSocketChannel.connect(Uri.parse('wss://localhost:7171/api/cards/log'));
  final channelStorage = WebSocketChannel.connect(
      Uri.parse('wss://192.168.0.173:7171/api/storages/log'));
  final channelUser =
      WebSocketChannel.connect(Uri.parse('wss://localhost:7171/users/log'));
  final channelReservation = WebSocketChannel.connect(
      Uri.parse('wss://192.168.0.173:7171/api/reservations/log'));

  @override
  void initState() {
    super.initState();
    isDark = AppPreferences.getIsOn();
    streamControler = channelControler.stream.asBroadcastStream();
    streamCard = channelCard.stream.asBroadcastStream();
    streamStorage = channelStorage.stream.asBroadcastStream();
    streamUser = channelUser.stream.asBroadcastStream();
    streamReservation = channelReservation.stream.asBroadcastStream();

    websocketData = StreamGroup.merge([
      streamControler,
      streamCard,
      streamStorage,
      streamUser,
      streamReservation
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateAppBar(context),
      body: Container(
          child: Column(
        children: [
          StreamBuilder(
            stream: websocketData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.connectionState == ConnectionState.active &&
                  snapshot.hasData) {
                return Center(
                  child: Text(
                    '${snapshot.data!.toString()}',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.done) {
                return const Center(
                  child: Text(
                    'No more data',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
              }

              return const Center(
                child: Text('No data'),
              );
            },
          ),
        ],
      )),
    );
  }
}
