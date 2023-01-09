import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/appbar.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Logs extends StatefulWidget {
  const Logs({Key? key}) : super(key: key);

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  final channelControler = WebSocketChannel.connect(
      Uri.parse('wss://192.168.85.9:7171/api/controller/log'));
  final channelCard =
      WebSocketChannel.connect(Uri.parse('wss://localhost:7171/api/cards/log'));
  final channelStorage = WebSocketChannel.connect(
      Uri.parse('wss://192.168.85.9:7171/api/storages/log'));
  final channelUser =
      WebSocketChannel.connect(Uri.parse('wss://localhost:7171/users/log'));
  final channelReservation = WebSocketChannel.connect(
      Uri.parse('wss://192.168.85.9:7171/api/reservations/log'));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generateAppBar(context),
      body: Container(
          child: Column(
        children: [
          StreamBuilder(
            stream: channelControler.stream,
            builder: (context, snapshot) {
              return Text(snapshot.hasData ? '${snapshot.data}' : '');
            },
          ),
          StreamBuilder(
            stream: channelCard.stream,
            builder: (context, snapshot) {
              return Text(snapshot.hasData ? '${snapshot.data}' : '');
            },
          ),
          StreamBuilder(
            stream: channelUser.stream,
            builder: (context, snapshot) {
              return Text(snapshot.hasData ? '${snapshot.data}' : '');
            },
          ),
          StreamBuilder(
            stream: channelReservation.stream,
            builder: (context, snapshot) {
              return Text(snapshot.hasData ? '${snapshot.data}' : '');
            },
          )
        ],
      )),
    );
  }

  @override
  void dispose() {
    channelControler.sink.close();
    channelCard.sink.close();
    channelUser.sink.close();
    channelReservation.sink.close();
    super.dispose();
  }
}
