// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../models/sensor.dart';

enum MqttCurrentConnectionState {
  IDLE,
  CONNECTING,
  CONNECTED,
  DISCONNECTED,
  ERROR_WHEN_CONNECTING
}

enum MqttSubscriptionState {
  IDLE,
  SUBSCRIBED
}

class MqttManager {
  late MqttServerClient client;
  late Stream<bool> mqttStream;

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;
  Map<String, Sensor> sensors = {};
  StreamController<bool> controller = StreamController<bool>.broadcast();
  

  MqttManager() {
    mqttStream = controller.stream;
  }

  void prepareMqttClient() async {
    _setupMqttClient();
    await _connectClient();
    _subscribeToTopic('sensor_1');
    _subscribeToTopic('sensor_2');
    _subscribeToTopic('sensor_3');
    _subscribeToTopic('sensor_4');
    _subscribeToTopic('sensor_5');
    _subscribeToTopic('sensor_6');
  }

  bool isMqttConnected() {
    return connectionState == MqttCurrentConnectionState.CONNECTED;
  } 

  void disconnect() {
    print('[MQTT client] _disconnect()');
    client.unsubscribe('sensor_1');
    client.unsubscribe('sensor_2');
    client.unsubscribe('sensor_3');
    client.unsubscribe('sensor_4');
    client.unsubscribe('sensor_5');
    client.unsubscribe('sensor_6');
    client.disconnect();
    _onDisconnected();
    sensors.clear();
  }

  Future<void> _connectClient() async {
    try {
      print('client connecting....');
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await client.connect('Esp32-TPMS', 'Abcd-3456');
    } on Exception catch (e) {
      print('client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      _notifyMqttChange();
      print('client connected');
    } else {
      print(
          'ERROR client connection failed - disconnecting, status is ${client.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }
  }

  void _setupMqttClient() {
    client = MqttServerClient.withPort('64422e2162014ec7b65bc70d4c1f3c4c.s2.eu.hivemq.cloud', 'Mobile-App-TPMS', 8883);
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  void _subscribeToTopic(String topicName) {
    print('Subscribing to the $topicName topic');
    client.subscribe(topicName, MqttQos.atMostOnce);

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> event) {
      final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
      var message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      Sensor sensor = Sensor.transformToModel(message);
      sensors[event[0].topic] = sensor;

      _notifyMqttChange();
      print('[Topic]: ${event[0].topic}');
      print(message);
    });
  }

  void _onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  void _onConnected() {
    connectionState = MqttCurrentConnectionState.CONNECTED;
    print('OnConnected client callback - Client connection was sucessful');
  }

  _notifyMqttChange() {
    controller.add(true);
  }
}

final MqttManager mqttManager = MqttManager();
