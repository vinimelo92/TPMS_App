class Configuration {
  String vehicleType = 'Not Defined';
  double minPressureValue = 20;
  double maxPressureValue = 45;
  double maxTemperatureValue = 60;

  Configuration();

  void setVehicleType(String vehicleType){
    this.vehicleType = vehicleType;
  }

  void setMinPressureValue(double minPressureValue){
    this.minPressureValue = minPressureValue;
  }

  void setMaxPressureValue(double maxPressureValue){
    this.maxPressureValue = maxPressureValue;
  }

  void setMaxTemperatureValue(double maxTemperatureValue){
    this.maxTemperatureValue = maxTemperatureValue;
  }
}

final Configuration configuration = Configuration();
