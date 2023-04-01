class Sensor {
  final String id;
  final double pressureValue;
  final double temperatureValue;
  final double battery;

  Sensor({
    required this.id,
    required this.pressureValue,
    required this.temperatureValue,
    required this.battery,
  });

  factory Sensor.transformToModel(String data) {
    var convertedData = data.split(",");

    return Sensor(
        id: 'sensor_${convertedData[0]}',
        pressureValue: double.parse(convertedData[1]),
        temperatureValue: double.parse(convertedData[2]),
        battery: double.parse(convertedData[3]),
    );
  }
}
