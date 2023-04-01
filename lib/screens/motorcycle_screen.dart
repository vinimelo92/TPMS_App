// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'dart:async';

import 'package:flutter/material.dart';
import '../models/configuration.dart';
import '../models/sensor.dart';
import '../providers/bluetooth_manager.dart';
import '../providers/mqtt_manager.dart';
import 'configuration_screen.dart';

class MotorCycleScreen extends StatefulWidget {
  const MotorCycleScreen({super.key});

  @override
  State<MotorCycleScreen> createState() => _MotorCycleScreenState();
}

class _MotorCycleScreenState extends State<MotorCycleScreen> {
  late StreamSubscription<bool> bluetoothSubscription;
  late StreamSubscription<bool> mqttSubscription;

  Sensor? getSensorInformation(String id) {
    if (bluetoothManager.sensors.isNotEmpty) {
      return bluetoothManager.sensors[id];
    }

    if (mqttManager.sensors.isNotEmpty) {
      return mqttManager.sensors[id];
    }

    return null;
  }

  Color? getContainerColor(String id) {
    Sensor? sensor = getSensorInformation(id);

    if (sensor == null) {
      return Colors.grey[200];
    }

    if ((sensor.temperatureValue >= configuration.maxTemperatureValue) ||
        (sensor.pressureValue <= configuration.minPressureValue) ||
        (sensor.pressureValue >= configuration.maxTemperatureValue)) {
      return Colors.red[600];
    }

    return Colors.white;
  }

  @override
  void initState() {
    bluetoothSubscription = bluetoothManager.bluetoothStream.listen((value) {
      setState(() {});
    });

    mqttSubscription = mqttManager.mqttStream.listen((value) {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[200],
          title: Text('Monitor de pressão'),
          centerTitle: true,
        ),
        drawer: Drawer(
          width: 200,
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  "TCC TPMS V1",
                  style: TextStyle(color: Colors.black),
                ),
                accountEmail: Text(
                  configuration.vehicleType,
                  style: TextStyle(color: Colors.black),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: const Text('Tela principal'),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      settings: const RouteSettings(
                          name: '/motorcycle_screen'),
                      builder: (context) => MotorCycleScreen()));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: const Text('Configurações'),
                onTap: () {
                  bluetoothSubscription.cancel();
                  mqttSubscription.cancel();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      settings: const RouteSettings(
                          name: '/car_screen/configuration_screen'),
                      builder: (context) => ConfigurationPage()));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.help),
                title: const Text('Suporte'),
              ),
              Divider(),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                width: 500,
                height: 650,
                child: Column(
                  children: [
                    Text('Utilize os botoes para iniciar',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                    Card(
                        elevation: 10.0,
                        child: SizedBox(
                          height: 65,
                          width: 200,
                          child: ListTile(
                            leading: Icon(
                              (bluetoothManager.connectionText) ==
                                          "Conectado" ||
                                      (bluetoothManager.bIsConnected)
                                  ? Icons.bluetooth_connected
                                  : Icons.bluetooth_disabled,
                              color: (bluetoothManager.connectionText) ==
                                          "Conectado" ||
                                      (bluetoothManager.bIsConnected)
                                  ? Colors.blue
                                  : Colors.grey,
                              size: 24.0,
                            ),
                            title: Text('BLE Status:',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(bluetoothManager.connectionText),
                            onLongPress: () async {
                              if (bluetoothManager.bIsConnected) {
                                bluetoothManager.stopScan();
                                setState(() {});
                              } else {
                                await bluetoothManager.startScan();
                                setState(() {});
                              }
                            },
                          ),
                        )),
                    Card(
                        elevation: 10.0,
                        child: SizedBox(
                          height: 65,
                          width: 200,
                          child: ListTile(
                            leading: Icon(
                              (mqttManager.isMqttConnected())
                                  ? Icons.wifi_outlined
                                  : Icons.wifi_off,
                              color: (mqttManager.isMqttConnected())
                                  ? Colors.blue
                                  : Colors.grey,
                              size: 24.0,
                            ),
                            title: Text('IoT Status:',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(mqttManager.isMqttConnected()
                                ? 'Conectado'
                                : 'Desconectado'),
                            onLongPress: () async {
                              if (mqttManager.isMqttConnected()) {
                                mqttManager.disconnect();
                                setState(() {});
                              } else {
                                mqttManager.prepareMqttClient();
                                setState(() {});
                              }
                            },
                          ),
                        )),
                  ],
                ),
              ),
              Positioned(
                  top: 430,
                  left: 5,
                  width: 100,
                  height: 120,
                  child: Container(
                    decoration: BoxDecoration(
                      color: getContainerColor('sensor_1'),
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Container(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    getSensorInformation('sensor_1')?.id ??
                                        'Sem disp.',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.tire_repair,
                                  color: Colors.black,
                                  size: 17,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    getSensorInformation('sensor_1')
                                                ?.pressureValue !=
                                            null
                                        ? '${getSensorInformation('sensor_1')?.pressureValue} PSI'
                                        : '--',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.device_thermostat,
                                  color: Colors.black,
                                  size: 17,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    getSensorInformation('sensor_1')
                                                ?.temperatureValue !=
                                            null
                                        ? '${getSensorInformation('sensor_1')?.temperatureValue} °C'
                                        : '--',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.battery_full,
                                  color: Colors.green,
                                  size: 17,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    getSensorInformation('sensor_1')?.battery !=
                                            null
                                        ? '${getSensorInformation('sensor_1')?.battery} V'
                                        : '--',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                  )),
              Positioned.fill(
                top: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'images/motorcycle_template.png',
                      height: 300,
                      width: 500,
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: 430,
                  left: 250,
                  width: 100,
                  height: 120,
                  child: Container(
                    decoration: BoxDecoration(
                      color: getContainerColor('sensor_2'),
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Container(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    getSensorInformation('sensor_2')?.id ??
                                        'Sem Disp.',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.tire_repair,
                                  color: Colors.black,
                                  size: 17,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    getSensorInformation('sensor_2')
                                                ?.pressureValue !=
                                            null
                                        ? '${getSensorInformation('sensor_2')?.pressureValue} PSI'
                                        : '--',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.device_thermostat,
                                  color: Colors.black,
                                  size: 17,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    getSensorInformation('sensor_2')
                                                ?.temperatureValue !=
                                            null
                                        ? '${getSensorInformation('sensor_2')?.temperatureValue} °C'
                                        : '--',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.battery_full,
                                  color: Colors.green,
                                  size: 17,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    getSensorInformation('sensor_2')?.battery !=
                                            null
                                        ? '${getSensorInformation('sensor_2')?.battery} V'
                                        : '--',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                  )),
            ],
          ),
        ));
  }
}
