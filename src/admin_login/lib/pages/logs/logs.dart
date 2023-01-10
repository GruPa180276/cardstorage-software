import 'package:flutter/material.dart';

import 'package:admin_login/pages/widget/appbar.dart';
import 'package:admin_login/config/adress.dart' as adres;
import 'package:web_socket_channel/web_socket_channel.dart';

class Logs extends StatefulWidget {
  const Logs({Key? key}) : super(key: key);

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  final channelControler =
      WebSocketChannel.connect(Uri.parse(adres.wssControler));
  final channelCard = WebSocketChannel.connect(Uri.parse(adres.wssCard));
  final channelStorage = WebSocketChannel.connect(Uri.parse(adres.wssStorage));
  final channelUser = WebSocketChannel.connect(Uri.parse(adres.wssUser));
  final channelReservation =
      WebSocketChannel.connect(Uri.parse(adres.wssReservation));

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
