class Vehicle{

  final String? licencePlateNumber;
  final String? vin;
  final String? manufacturer;
  final String? model;
  final int? year;
  final String? color;
  final int? typeId;

  const Vehicle({
    required this.licencePlateNumber,
    required this.vin,
    required this.manufacturer,
    required this.model,
    required this.year,
    required this.color,
    required this.typeId
  });

  factory Vehicle.fromJson(Map<String, dynamic> json){
    return switch(json){
      {
       "licencePlateNumber": String licencePlateNumber,
        "VIN": String vin,
        "manufacturer": String manufacturer,
        "model": String model,
        "year": int year,
        "color": String color,
        "typeId": int typeId,
      }
      =>
      Vehicle(
          licencePlateNumber: licencePlateNumber,
          vin: vin,
          manufacturer: manufacturer,
          model: model,
          year: year,
          color: color,
          typeId: typeId
      ),
      _ => throw Exception("Error parsing data"),
    };
  }
}

class VehicleBuilder{

  String? _licencePlateNumber;
  String? _vin;
  String? _manufacturer;
  String? _model;
  int? _year;
  String? _color;
  int? _typeId;

  VehicleBuilder setLicencePlateNumber (String value) {
    _licencePlateNumber = value;
    return this;
  }

  VehicleBuilder setVin (String value) {
    _vin = value;
    return this;
  }

  VehicleBuilder setManufacturer(String value) {
    _manufacturer = value;
    return this;
  }

  VehicleBuilder setModel(String value) {
    _model = value;
    return this;
  }

  VehicleBuilder setYear(int value) {
    _year = value;
    return this;
  }

  VehicleBuilder setColor(String value) {
    _color = value;
    return this;
  }

  VehicleBuilder setTypeId(int value) {
    _typeId = value;
    return this;
  }

  Vehicle build(){
    return Vehicle(
        licencePlateNumber: _licencePlateNumber,
        vin: _vin,
        manufacturer: _manufacturer,
        model: _model,
        year: _year,
        color: _color,
        typeId: _typeId
    );
  }
}