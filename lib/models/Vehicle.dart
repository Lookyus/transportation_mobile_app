class Vehicle{

  String? licencePlateNumber;
  String? vin;
  String? manufacturer;
  String? model;
  int? year;
  String? color;
  int? typeId;

  Vehicle({
    required this.licencePlateNumber,
    required this.vin,
    required this.manufacturer,
    required this.model,
    required this.year,
    required this.color,
    required this.typeId
  });

  factory Vehicle.fromJson(Map<String, dynamic> json){
    return Vehicle(
        licencePlateNumber: json['licencePlateNumber'] ?? '',
        vin: json['VIN'] ?? '',
        manufacturer: json['manufacturer'] ?? '',
        model: json['model'] ?? '',
        year: json['year'] ?? '',
        color: json['color'] ?? '',
        typeId: json['typeId'] ?? ''
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "licencePlateNumber": licencePlateNumber ?? "test2",
      "VIN": vin ?? "test2",
      "manufacturer": manufacturer ?? "test2",
      "model": model ?? "2test",
      "year": year ?? 2000,
      "color": color ?? "test2",
      "typeId": typeId ?? 4,
    };
  }
}