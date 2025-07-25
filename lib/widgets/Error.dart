import 'package:flutter/material.dart';
import 'package:transportation_mobile_app/resources/constants/colors.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback function;
  const ErrorMessage({super.key, required this.message, required this.function});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Text(message),
            const SizedBox(height: 10,),
            ElevatedButton(
                onPressed: (){
                  function();
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(AppColors.primary)
                ),
                child: const Text(
                    "Try again",
                    style: TextStyle(color: Colors.white),
                )
            )
          ]
      ),
    );
  }
}
