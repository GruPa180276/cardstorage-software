import 'package:web_socket_channel/io.dart';
import 'package:rfidapp/pages/generate/widget/request_timer.dart';

class Websocket {
  static IOWebSocketChannel? channel;
  static connect() {
    try {
      channel = IOWebSocketChannel.connect(
          Uri.parse('wss://192.168.83.84:7171/api/controller/log'));

      RequestTimer.streamListener(channel!);
    } catch (e) {}
  }
}
