class CarQueryVehicle{

  final String makeId;
  final String makeDisplay;
  final String makeIsCommon;
  final String makeCountry;

  const CarQueryVehicle({required this.makeId, required this.makeDisplay, required this.makeIsCommon, required this.makeCountry});

  factory CarQueryVehicle.fromJson(Map<String, dynamic> json){
    return CarQueryVehicle(
        makeId: json['make_id'] ?? '',
        makeDisplay: json['make_display'] ?? '',
        makeIsCommon: json['make_common'] ?? '',
        makeCountry: json ['make_country'] ?? ''
    );
  }
}