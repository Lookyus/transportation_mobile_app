import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:transportation_mobile_app/repositories/VehicleRepository.dart';
import 'package:transportation_mobile_app/services/VehicleService.dart';
import 'package:transportation_mobile_app/widgets/Error.dart';

import '../../models/Vehicle.dart';
import '../../resources/constants/colors.dart';
import 'package:http/http.dart' as http;

class VehicleDetails extends StatefulWidget {
  final Vehicle vehicle;
  const VehicleDetails({super.key, required this.vehicle});

  @override
  State<VehicleDetails> createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {

  Future<http.Response>? _response;
  final vehicleRepository = VehicleRepository(vehicleService: VehicleService());

  void createVehicle(){
    setState(() {
      _response = vehicleRepository.createVehicle(widget.vehicle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _response == null ?
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                  "Pregledajte detalje svog vozila:",
                  style: TextStyle(
                      color: AppColors.textOnLight,
                      fontSize: 23,
                      fontWeight: FontWeight.bold
                  )
              ),
              Text(widget.vehicle.manufacturer ?? 'Error loading vehicle manufacturer'),
              Text(widget.vehicle.model ?? 'Error loading vehicle model'),

              ElevatedButton(
                  onPressed: (){
                    createVehicle();
                  },
                  child: const Text("SAVE")
              )
            ],
          ),
        )
            :
        FutureBuilder(
          future: _response,
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.hasData){
              if(snapshot.data!.statusCode == 200){
                return const Center(
                  child: Text("Success creating vehicle!"),
                );
              }
              if(snapshot.data!.statusCode != 200){
                var data = jsonDecode(snapshot.data!.body)['message'] as String;

                return Center(
                  child: Text("Error creating vehicle.Status code: ${snapshot.data!.statusCode}. Message: $data"),
                );
              }
            }
            if(snapshot.hasError){
              return ErrorMessage(
                  message: "Error saving vehicle",
                  function: createVehicle
              );
            }
            return const SizedBox.shrink();

          },
        ),
      )
    );
  }
}
