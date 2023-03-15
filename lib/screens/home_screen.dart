// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';

import '../models/sensor.dart';
import '../providers/bluetooth_manager.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Sensor? getSensorInformation(String id) {

    if (bluetoothManager.sensors.isEmpty){
      return null;
    }

    return bluetoothManager.sensors[id];
  }

  @override
  void initState() {
    bluetoothManager.stream.listen((value) {
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
          width: 190,
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.home),
                title: const Text('Tela principal'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: const Text('Configurações'),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.help),
                title: const Text('Suporte'),
              ),
              Divider(
                color: Colors.transparent,
                height: 25.0,
              ),
              ListTile(
                title: const Text('TPMS v1'),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: 600,
                child: Column(
                  children: [
                    Card(
                        color: Colors.white,
                        child: SizedBox(
                          // width: 300,
                          height: 70,
                          child: ListTile(
                              subtitle: Text(
                                'Pressione o botao abaixo para conectar',
                                textAlign: TextAlign.center,
                              ),
                              title: Text(
                                'Conexão com Bluetooth',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              )),
                        )),
                    Card(
                      elevation: 10.0,
                        child: SizedBox(
                      height: 65,
                      width: 280,
                      child: ListTile(
                        leading: Icon(
                          (bluetoothManager.connectionText) ==
                                      "Dispositivo Conectado" ||
                                  (bluetoothManager.bIsConnected)
                              ? Icons.bluetooth_connected
                              : Icons.bluetooth_disabled,
                          color: (bluetoothManager.connectionText) ==
                                      "Dispositivo Conectado" ||
                                  (bluetoothManager.bIsConnected)
                              ? Colors.blue
                              : Colors.grey,
                          size: 36.0,
                        ),
                        title: Text('Bluetooth Status:',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold)),
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
                  ],
                ),
              ),
              Positioned(
                  top: 190,
                  left: 5,
                  width: 100,
                  height: 120,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                                    getSensorInformation('Sensor_1')?.id  ?? 'Sem disp.',
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
                                    getSensorInformation('Sensor_1')?.pressureValue  ?? '--',
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
                                    getSensorInformation('Sensor_1')?.temperatureValue  ?? '--',
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
                                    '3.1V',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                  )),
              Positioned(
                  top: 350,
                  left: 5,
                  width: 100,
                  height: 120,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                                    getSensorInformation('Sensor_3')?.id  ?? 'Sem disp.',
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
                                    getSensorInformation('Sensor_3')?.pressureValue  ?? '--',
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
                                    getSensorInformation('Sensor_3')?.temperatureValue  ?? '--',
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
                                    '3.1V',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                  )),
              Positioned(
                  top: 480,
                  left: 5,
                  width: 100,
                  height: 120,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                                    getSensorInformation('Sensor_5')?.id  ?? 'Sem disp.',
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
                                    getSensorInformation('Sensor_5')?.pressureValue  ?? '--',
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
                                    getSensorInformation('Sensor_5')?.temperatureValue  ?? '--',
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
                                    '3.1V',
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
                top: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'images/truck.png',
                      height: 300,
                      width: 500,
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: 190,
                  left: 250,
                  width: 100,
                  height: 120,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                                    getSensorInformation('Sensor_2')?.id  ?? '--',
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
                                    getSensorInformation('Sensor_2')?.pressureValue  ?? '--',
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
                                    getSensorInformation('Sensor_2')?.temperatureValue  ?? '--',
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
                                    '3.1V',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                  )),
              Positioned(
                  top: 350,
                  left: 250,
                  width: 100,
                  height: 120,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
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
                                    getSensorInformation('Sensor_4')?.id  ?? 'Sem Disp.',
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
                                    getSensorInformation('Sensor_4')?.pressureValue  ?? '--',
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
                                    getSensorInformation('Sensor_4')?.temperatureValue  ?? '--',
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
                                    getSensorInformation('Sensor_4')?.battery  ?? '--',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                  )),
              Positioned(
                  top: 480,
                  left: 250,
                  width: 100,
                  height: 120,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red[600],
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
                                    getSensorInformation('Sensor_6')?.id  ?? 'Sem Disp.',
                                    style: TextStyle(
                                      color: Colors.white,
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
                                    getSensorInformation('Sensor_6')?.pressureValue  ?? '--',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
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
                                    getSensorInformation('Sensor_6')?.temperatureValue  ?? '--',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
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
                                    '3.1V',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
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
