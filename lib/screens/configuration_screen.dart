// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  String _vehicleType = '';
  double _minPressureValue = 20;
  double _maxPressureValue = 20;
  double _minTemperatureValue = 20;
  double _maxTemperatureValue = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[200],
          title: Text('Configurações', textAlign: TextAlign.center),
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
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Selecione o tipo de veículo',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                  width: 400,
                  height: 380, // constrain height
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(5),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: <Widget>[
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _vehicleType = 'Motorcycle';
                              });
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                color: _vehicleType == 'Motorcycle'
                                    ? Colors.lightBlue[100]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Ink.image(
                                    fit: BoxFit.contain,
                                    image: AssetImage('images/motorcycle.png'),
                                    height: 50,
                                    width: 80,
                                  ),
                                  Padding(padding: EdgeInsets.all(5)),
                                  Text('Moto',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _vehicleType = 'Car';
                              });
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                color: _vehicleType == 'Car'
                                    ? Colors.lightBlue[100]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Ink.image(
                                    fit: BoxFit.contain,
                                    image: AssetImage('images/car.png'),
                                    height: 50,
                                    width: 80,
                                  ),
                                  Padding(padding: EdgeInsets.all(5)),
                                  Text('Carro',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _vehicleType = 'Truck';
                              });
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                color: _vehicleType == 'Truck'
                                    ? Colors.lightBlue[100]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Ink.image(
                                    fit: BoxFit.contain,
                                    image: AssetImage('images/truck_1.png'),
                                    height: 50,
                                    width: 80,
                                  ),
                                  Padding(padding: EdgeInsets.all(5)),
                                  Text('Caminhão',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Divider(),
              Text(
                'Configuração pressão do pneu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Max'),
                  Slider(
                    value: _maxPressureValue,
                    max: 40,
                    min: 20,
                    divisions: 10,
                    thumbColor: Colors.blue[200],
                    activeColor: Colors.blue[200],
                    onChanged: (double value) {
                      setState(() {
                        _maxPressureValue = value;
                      });
                    },
                  ),
                  Text('$_maxPressureValue PSI')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Min'),
                  Slider(
                    value: _minPressureValue,
                    max: 40,
                    min: 20,
                    divisions: 10,
                    thumbColor: Colors.blue[200],
                    activeColor: Colors.blue[200],
                    onChanged: (double value) {
                      setState(() {
                        _minPressureValue = value;
                      });
                    },
                  ),
                  Text('$_minPressureValue PSI')
                ],
              ),
              Divider(),
              Text(
                'Configuração temperatura do pneu',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Max'),
                  Slider(
                    value: _maxTemperatureValue,
                    max: 40,
                    min: 20,
                    divisions: 10,
                    thumbColor: Colors.blue[200],
                    activeColor: Colors.blue[200],
                    onChanged: (double value) {
                      setState(() {
                        _maxTemperatureValue = value;
                      });
                    },
                  ),
                  Text('$_maxTemperatureValue°C')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Min'),
                  Slider(
                    value: _minTemperatureValue,
                    max: 40,
                    min: 20,
                    divisions: 10,
                    thumbColor: Colors.blue[200],
                    activeColor: Colors.blue[200],
                    onChanged: (double value) {
                      setState(() {
                        _minTemperatureValue = value;
                      });
                    },
                  ),
                  Text('$_minTemperatureValue°C')
                ],
              ),
            ],
          ),
        ));
  }
}
