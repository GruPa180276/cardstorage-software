import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:rfidapp/pages/generate/widget/mqtt_timer.dart';
import 'package:rfidapp/domain/storage_properties.dart';

class MQTTClientManager {
  static MqttServerClient _client = MqttServerClient.withPort(
      StorageProperties.getIpAdress()!, 'mobile_client', 1883);
  static late StreamSubscription _subscription;
  static late BuildContext _context;

  static Future<int> connect() async {
    _client.logging(on: true);

    _client.keepAlivePeriod = 60;
    _client.onConnected = onConnected;
    _client.onDisconnected = onDisconnected;
    _client.onSubscribed = onSubscribed;
    _client.pongCallback = pong;
    final connMessage =
        MqttConnectMessage().startClean().withWillQos(MqttQos.atLeastOnce);
    _client.connectionMessage = connMessage;

    try {
      await _client.connect("mqtt", "eclipse");
    } on NoConnectionException catch (e) {
      print('MQTTClient::Client exception - $e');
      _client.disconnect();
    } on SocketException catch (e) {
      print('MQTTClient::Socket exception - $e');
      _client.disconnect();
    }

    return 0;
  }

  static void disconnect() {
    _client.disconnect();
  }

  static void _onMessage(List<MqttReceivedMessage> event) {
    final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;

    final String message =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    Map response = json.decode(message);
    print(response);
    MqttTimer.startTimer(_context, "to-sign-up");
  }

  static void subscribe(String topic, BuildContext buildContext) {
    try {
      _context = buildContext;
      _client.subscribe(topic, MqttQos.atLeastOnce);
      _subscription = _client.updates!.listen(_onMessage);
    } catch (e) {
      print(e);
    }
  }

  static void onConnected() {
    print('MQTTClient::Connected');
  }

  static void onDisconnected() {
    print('MQTTClient::Disconnected');
  }

  static void onSubscribed(String topic) {
    print('MQTTClient::Subscribed to topic: $topic');
  }

  static void pong() {
    print('MQTTClient::Ping response received');
  }

  static void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  static Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream() {
    return _client.updates;
  }
}
