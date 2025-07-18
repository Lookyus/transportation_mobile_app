import 'package:flutter/material.dart';
import 'package:transportation_mobile_app/models/CarQueryVehicle.dart';
import 'package:transportation_mobile_app/pages/add_vehicle/add_model.dart';
import 'package:transportation_mobile_app/repositories/VehicleRepository.dart';
import 'package:transportation_mobile_app/resources/constants/colors.dart';
import 'package:transportation_mobile_app/services/VehicleService.dart';
import 'package:transportation_mobile_app/widgets/Error.dart';
import 'package:transportation_mobile_app/models/Vehicle.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {

  late Future<List<CarQueryVehicle>> _vehiclesList;
  final vehicleRepository = VehicleRepository(vehicleService: VehicleService());


  @override
  void initState() {
    _vehiclesList = vehicleRepository.getCarQueryVehicles();
  }
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: _vehiclesList,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
        
                if(snapshot.hasData){
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Text(
                            "Odaberite marku svog vozila:",
                            style: TextStyle(
                              color: AppColors.textOnLight,
                              fontSize: 23,
                              fontWeight: FontWeight.bold
                            ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) => ListTile(
                            title: Padding(padding: const EdgeInsets.symmetric(horizontal: 20),child: Text(snapshot.data![index].makeDisplay)),
                            selected: index == selectedIndex,
                            selectedColor: AppColors.secondary,
                            onTap: (){
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        color: AppColors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children:[
                            IconButton(
                              onPressed: (){

                                final vehicle = VehicleBuilder()
                                .setManufacturer(snapshot.data![selectedIndex].makeDisplay)
                                .build();

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AddModel(vehicle: vehicle))
                                );
                              },
                              icon: const Icon(
                                  Icons.navigate_next,
                                  size: 50,
                                  color: AppColors.secondary,
                              ),
                            ),
                          ]
                        ),
                      )
                    ],
                  );
                }else{
                  return const ErrorMessage(message: "There was error loading vehicles");
                }
              }else{
                return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                      backgroundColor: AppColors.primary,
                    )
                );
              }
            }
        ),
      )
    );
  }
}

class ListItem extends StatelessWidget {
  final String item;
  const ListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
              item,
              style: const TextStyle(
                color: AppColors.textOnLight,
                fontWeight: FontWeight.w500,
                fontSize: 15
              ),
          )
        ],
      ),
    );
  }
}
