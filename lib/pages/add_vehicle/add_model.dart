import 'package:flutter/material.dart';
import 'package:transportation_mobile_app/models/Vehicle.dart';

class AddModel extends StatefulWidget {
  final Vehicle vehicle;

  const AddModel({super.key, required this.vehicle});

  @override
  State<AddModel> createState() => _AddModelState();
}

class _AddModelState extends State<AddModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(widget.vehicle.manufacturer as String),
        ),
      ),
    );
  }
}
