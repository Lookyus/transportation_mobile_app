import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transportation_mobile_app/resources/constants/endpoints.dart';

class VehicleService{

  Future<List<Map<String, dynamic>>> fetchCarQueryVehicleMakes() async {

    try{

      final response = await http.get(
          Uri.parse(ApiEndpoints.carQueryBaseUrl+ApiEndpoints.carQueryCarMakes)
      );

      if(response.statusCode != 200){
        throw Exception("Error fetching car make from CarQuery!");
      }

      final body = response.body;
      final data = jsonDecode(body);

      final makes = data['Makes'] as List<dynamic>;
      return makes.cast<Map<String, dynamic>>();

    }catch(_){
      rethrow;
    }
  }


  Future<List<Map<String, dynamic>>> fetchCarQueryModelsOfAMake(String carMake) async {

    try{
      final response = await http.get(
          Uri.parse(ApiEndpoints.carQueryBaseUrl+ApiEndpoints.carQueryModels+carMake)
      );

      if(response.statusCode != 200){
        throw Exception("Error fetching models of a car make from CarQUery!");
      }

      final body = response.body;
      final data = jsonDecode(body);
      final models = data['Models'] as List<dynamic>;
      return models.cast<Map<String, dynamic>>();
    }catch(_){
      rethrow;
    }
  }

  Future<http.Response> createVehicle(Map<String, dynamic> vehicleMap) async {
    try{

      const bearerToken = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsInVzZXJSb2xlIjoxLCJpYXQiOjE3NTM0MDA0OTgsImV4cCI6MTc1NjQwMDQ5OH0.VGG4z2AIn8ozkQrU_vPDQqVOknsonayjdnDP2Bg_VQg';

      final response = http.post(
          Uri.parse(ApiEndpoints.baseUrl+ApiEndpoints.vehicleCreate),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': bearerToken
          },
        body: jsonEncode(vehicleMap)
      );

      return response;
    }catch(_){
      rethrow;
    }
  }
}