import 'dart:async';
import 'dart:convert' show utf8;
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothManager {
  
  // Device identification (ESP32)
  final String SERVICE_UUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  final String CHARACTERISTIC_UUID_TX = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
  final String CHARACTERISTIC_UUID_RX = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";
  final String TARGET_DEVICE_NAME = "ESP32-BLE";

  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamSubscription<ScanResult> scanSubScription;

  // Variables for bluetooth
  BluetoothDevice targetDevice;
  BluetoothCharacteristic targetCharacteristicTX;
  BluetoothCharacteristic targetCharacteristicRX;

  // Variable for display info
  String connectionText = "Device Disconnected";
  String sCounterValue = "--";

  bool bIsConnected = false;
  bool bEnableRealTimeCounter = false;
  int iStatePauseOrPlay = 0;


  startScan() {
    setState(() {
      connectionText = "Start Scanning";
    });

    scanSubScription = flutterBlue
        .scan(
      allowDuplicates: false,
      scanMode: ScanMode.lowLatency,
      timeout: const Duration(seconds: 12),
    )
        .listen((scanResult) {
      if (scanResult.device.name == TARGET_DEVICE_NAME) {
        stopScan();
        setState(() {
          connectionText = "Found Target Device";
        });

        targetDevice = scanResult.device;
        connectToDevice();
      }
    }, onDone: () => stopScan());
  }

  stopScan() {
    scanSubScription?.cancel();
    scanSubScription = null;
  }

  connectToDevice() async {
    if (targetDevice == null) return;

    setState(() {
      connectionText = "Device Connecting";
    });

    await targetDevice.connect();
    setState(() {
      connectionText = "Device Connected";
    });
    discoverServices();
  }

  disconnectFromDevice() {
    if (targetDevice == null) return;

    targetDevice.disconnect();
    targetDevice = null;
    bIsConnected = false;
    bEnableRealTimeCounter = false;
    setState(() {
      connectionText = "Device Disconnected";
    });
  }

  discoverServices() async {
    if (targetDevice == null) return;

    List<BluetoothService> services = await targetDevice.discoverServices();
    services.forEach((service) {
      // do something with service
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          print(characteristic.uuid.toString());
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID_TX) {
            targetCharacteristicTX = characteristic;
            bIsConnected = true;
            setState(() {
              connectionText = "Connected to ${targetDevice.name}";
            });
          }
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID_RX) {
            targetCharacteristicRX = characteristic;
            targetCharacteristicRX.setNotifyValue(true);
            bIsConnected = true;
          }
        });
      }
    });

    services.clear();
  }

  sendData(String data) {
    if (targetCharacteristicTX == null) return;

    List<int> bytes = utf8.encode(data);
    targetCharacteristicTX.write(bytes);
  }

  readData(String data) {
    if (bIsConnected) {
      targetCharacteristicRX.value.listen((event) {
        if (bEnableRealTimeCounter) {
          return utf8.decode(event);
        }
      });
    }
  }
}

final BluetoothManager userService = new BluetoothManager();
