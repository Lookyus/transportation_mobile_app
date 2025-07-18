import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transportation_mobile_app/resources/constants/endpoints.dart';

class VehicleService{

  Future<List<Map<String, dynamic>>> fetchCarQueryVehicleMakes() async {

    try{

      final response = await http.get(
          Uri.parse(ApiEndpoints.carQueryBaseUrl+ApiEndpoints.carQueryCarMakes)
      );

      if(response.statusCode == 200){
        final body = response.body;
        final data = jsonDecode(body);

        final makes = data['Makes'] as List<dynamic>;
        return makes.cast<Map<String, dynamic>>();
      }

      throw Exception("Error fetching data");
    }catch(_){
      rethrow;
    }
  }
}