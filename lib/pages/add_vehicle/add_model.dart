import 'package:flutter/material.dart';
import 'package:transportation_mobile_app/models/CarQueryModel.dart';
import 'package:transportation_mobile_app/models/Vehicle.dart';
import 'package:transportation_mobile_app/pages/add_vehicle/add_vehicle_details.dart';
import 'package:transportation_mobile_app/repositories/VehicleRepository.dart';
import 'package:transportation_mobile_app/services/VehicleService.dart';
import 'package:transportation_mobile_app/vehicles/add_vehicle.dart';

import '../../resources/constants/colors.dart';
import '../../widgets/Error.dart';

class AddModel extends StatefulWidget {
  final Vehicle vehicle;

  const AddModel({super.key, required this.vehicle});

  @override
  State<AddModel> createState() => _AddModelState();
}

class _AddModelState extends State<AddModel> {

  late Future<List<CarQueryModel>> _listOfModels;
  final vehicleRepository = VehicleRepository(vehicleService: VehicleService());
  int selectedIndex = -1;
  var isNextButtonEnabled = false;

  @override
  void initState() {
    _listOfModels = vehicleRepository.getCarQueryModels(widget.vehicle.manufacturer as String);
  }

  void fetchListOfModels () {
    setState(() {
      _listOfModels = vehicleRepository.getCarQueryModels(widget.vehicle.manufacturer as String);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _listOfModels,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasData){
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text(
                          "Odaberite model vaseg vozila:",
                          style: TextStyle(
                              color: AppColors.textOnLight,
                              fontSize: 23,
                              fontWeight: FontWeight.bold
                          )
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) => ListTile(
                            selectedColor: AppColors.secondary,
                            selected: index == selectedIndex,
                            title: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),child: Text(snapshot.data![index].modelName)),
                            onTap: (){
                              setState(() {
                                selectedIndex = index;
                                isNextButtonEnabled = true;
                              });
                            },
                          )
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: (){
                            if(!isNextButtonEnabled){
                              return;
                            }
                            widget.vehicle.model = snapshot.data![selectedIndex].modelName;
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VehicleDetails(vehicle: widget.vehicle)));
                          },
                          icon: Icon(
                            Icons.navigate_next,
                            size: 50,
                            color: isNextButtonEnabled ? AppColors.secondary : Colors.grey,
                          ),
                        ),
                      ],
                    )
                  ],
                );
              }else{
                return ErrorMessage(
                    message: "There was error loading vehicles",
                    function: fetchListOfModels,
                );
              }
            }else{
             return const Center(
               child: CircularProgressIndicator(),
             );
            }
          },
        ),
      ),
    );
  }
}
