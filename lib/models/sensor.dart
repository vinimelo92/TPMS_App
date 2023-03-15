class Sensor {
  final String id;
  final String pressureValue;
  final String temperatureValue;
  final String battery;

  Sensor({
    required this.id,
    required this.pressureValue,
    required this.temperatureValue,
    required this.battery,
  });

  factory Sensor.transformToModel(String data) {
    var convertedData = data.split(",");

    return Sensor(
        id: 'Sensor_${convertedData[0]}',
        pressureValue: '${convertedData[1]} PSI',
        temperatureValue: '${convertedData[2]} °C',
        battery: '${convertedData[3]} V',
    );
  }
}
