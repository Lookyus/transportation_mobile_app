import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle({super.key});

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints){
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: const IntrinsicHeight(
                child: Column(
                  children: [
                    Center(
                      child: Text('Here you can add you vehicles'),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
