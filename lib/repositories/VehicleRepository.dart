import 'package:transportation_mobile_app/services/VehicleService.dart';

import '../models/CarQueryVehicle.dart';

class VehicleRepository{

  final VehicleService _vehicleService;

  VehicleRepository({required vehicleService}) : this._vehicleService = vehicleService;

  Future<List<CarQueryVehicle>> getCarQueryVehicles() async {
    final vehicleJsonList = await _vehicleService.fetchCarQueryVehicleMakes();
    return vehicleJsonList.map((vehicleJson) => CarQueryVehicle.fromJson(vehicleJson)).toList();
  }
}