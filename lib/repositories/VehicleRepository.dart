import 'package:transportation_mobile_app/models/CarQueryModel.dart';
import 'package:transportation_mobile_app/models/Vehicle.dart';
import 'package:transportation_mobile_app/services/VehicleService.dart';

import '../models/CarQueryVehicle.dart';
import 'package:http/http.dart' as http;

class VehicleRepository{

  final VehicleService _vehicleService;

  VehicleRepository({required vehicleService}) : this._vehicleService = vehicleService;

  Future<List<CarQueryVehicle>> getCarQueryVehicles() async {
    final vehicleJsonList = await _vehicleService.fetchCarQueryVehicleMakes();
    return vehicleJsonList.map((vehicleJson) => CarQueryVehicle.fromJson(vehicleJson)).toList();
  }

  Future<List<CarQueryModel>> getCarQueryModels(String carMake) async {

    final vehicleModelsJsonList = await _vehicleService.fetchCarQueryModelsOfAMake(carMake);
    return vehicleModelsJsonList.map((vehicleJson) => CarQueryModel.fromJson(vehicleJson)).toList();
  }

  Future<http.Response> createVehicle(Vehicle vehicle) async {
    try{
      final vehicleMap = vehicle.toJson();
      final vehicleService = VehicleService();
      final response = vehicleService.createVehicle(vehicleMap);
      return response;
    }catch(_){
      rethrow;
    }
  }
}