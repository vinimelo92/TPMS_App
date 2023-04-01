import 'dart:async';
import 'dart:convert' show json, utf8;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:tpms_app/models/sensor.dart';

class BluetoothManager {
  final String SERVICE_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  final String CHARACTERISTIC_UUID_TX = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
  final String CHARACTERISTIC_UUID_RX = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";
  final String TARGET_DEVICE_NAME = "ESP32";

  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  late BluetoothDevice targetDevice;
  late BluetoothCharacteristic targetCharacteristicTX;
  late BluetoothCharacteristic targetCharacteristicRX;
  late Stream<bool> bluetoothStream;

  String connectionText = "Desconectado";
  String receivedData = 'Empty Value';
  Map<String, Sensor> sensors = {};
  bool bIsConnected = false;

  StreamController<bool> controller = StreamController<bool>.broadcast();

  BluetoothManager() {
    bluetoothStream = controller.stream;
  }

  startScan() async {
    flutterBlue.stopScan();
    flutterBlue.startScan(timeout: const Duration(seconds: 4));

    flutterBlue.scanResults.listen((results) async {
      for (ScanResult r in results) {
        if (TARGET_DEVICE_NAME == r.device.name && TARGET_DEVICE_NAME != '') {
          flutterBlue.stopScan();
          connectionText = "Dispositivo encontrado";
          _notifyBluetoothDataChange();

          targetDevice = r.device;
          await connectToDevice();
        }
      }
    });
  }

  stopScan() {
    flutterBlue.stopScan();
    _disconnectFromDevice();
    sensors.clear();
    _notifyBluetoothDataChange();
  }

  connectToDevice() async {
    connectionText = "Conectando...";
    _notifyBluetoothDataChange();

    await targetDevice.connect();
    connectionText = "Conectado";
    _notifyBluetoothDataChange();
    _discoverServices();
  }

  _disconnectFromDevice() {
    targetDevice.disconnect();
    bIsConnected = false;
    connectionText = "Desconectado";
    _notifyBluetoothDataChange();
  }

  _discoverServices() async {
    List<BluetoothService> services = await targetDevice.discoverServices();
    for (var service in services) {
      if (service.uuid.toString() == SERVICE_UUID) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID_TX) {
            targetCharacteristicTX = characteristic;
            bIsConnected = true;
            connectionText = "Conectado em ${targetDevice.name}";
            _readData();
            _notifyBluetoothDataChange();
          }

          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID_RX) {
            targetCharacteristicRX = characteristic;
            targetCharacteristicRX.setNotifyValue(true);
            bIsConnected = true;
            _notifyBluetoothDataChange();
          }
        }

        flutterBlue.stopScan();
      }
    }

    services.clear();
  }

  _readData() {
    if (bIsConnected) {
      targetCharacteristicRX.value.listen((event) {
        receivedData = utf8.decode(event);
        if (receivedData.isEmpty) {
          return;
        }

        Sensor sensor = Sensor.transformToModel(receivedData);
        sensors[sensor.id] = sensor;
        _notifyBluetoothDataChange();
      });
    }
  }

  _notifyBluetoothDataChange() {
    controller.add(true);
  }
}

final BluetoothManager bluetoothManager = BluetoothManager();
