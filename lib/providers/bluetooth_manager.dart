import 'dart:async';
import 'dart:convert' show json, utf8;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:tpms_app/models/sensor.dart';

class BluetoothManager {
  // Device identification (ESP32)
  final String SERVICE_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  final String CHARACTERISTIC_UUID_TX = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
  final String CHARACTERISTIC_UUID_RX = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";
  final String TARGET_DEVICE_NAME = "ESP32";

  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  // Variables for bluetooth
  late BluetoothDevice targetDevice;
  late BluetoothCharacteristic targetCharacteristicTX;
  late BluetoothCharacteristic targetCharacteristicRX;

  // Variable for display info
  String connectionText = "Dispositivo desconectado";
  String receivedData = 'Empty Value';
  Map<String, Sensor> sensors = {};

  bool bIsConnected = false;

  StreamController<bool> controller = StreamController<bool>();
  late Stream stream;

  BluetoothManager() {
    stream = controller.stream;
  }

  startScan() async {
    flutterBlue.stopScan();
    flutterBlue.startScan(timeout: const Duration(seconds: 4));

    flutterBlue.scanResults.listen((results) async {
      for (ScanResult r in results) {
        if (TARGET_DEVICE_NAME == r.device.name && TARGET_DEVICE_NAME != '') {
          flutterBlue.stopScan();
          connectionText = "Dispositivo encontrado";
          refreshApp();

          targetDevice = r.device;
          await connectToDevice();
        }
      }
    });
  }

  stopScan() {
    flutterBlue.stopScan();
    disconnectFromDevice();
    sensors.clear();
    refreshApp();
  }

  connectToDevice() async {
    connectionText = "Conectando no dispositivo";
    refreshApp();

    await targetDevice.connect();
    connectionText = "Dispositivo conectado";
    refreshApp();
    discoverServices();
  }

  disconnectFromDevice() {
    targetDevice.disconnect();
    bIsConnected = false;
    connectionText = "Dispositivo desconectado";
    refreshApp();
  }

  discoverServices() async {
    List<BluetoothService> services = await targetDevice.discoverServices();
    for (var service in services) {
      // do something with service
      if (service.uuid.toString() == SERVICE_UUID) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID_TX) {
            targetCharacteristicTX = characteristic;
            bIsConnected = true;
            connectionText = "Conectado em ${targetDevice.name}";
            readData();
            refreshApp();
          }

          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID_RX) {
            targetCharacteristicRX = characteristic;
            targetCharacteristicRX.setNotifyValue(true);
            bIsConnected = true;
            refreshApp();
          }
        }

        flutterBlue.stopScan();
      }
    }

    services.clear();
  }

  sendData(String data) {
    List<int> bytes = utf8.encode(data);
    targetCharacteristicTX.write(bytes);
  }

  readData() {
    if (bIsConnected) {
      targetCharacteristicRX.value.listen((event) {
        receivedData = utf8.decode(event);
        if (receivedData.isEmpty) {
          return;
        }

        Sensor sensor = Sensor.transformToModel(receivedData);
        sensors[sensor.id] = sensor;
        refreshApp();
      });
    }
  }

  refreshApp() {
    controller.add(true);
  }
}

final BluetoothManager bluetoothManager = BluetoothManager();
