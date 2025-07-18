import 'package:flutter/material.dart';
import 'package:transportation_mobile_app/resources/constants/strings.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home),
              label: AppStrings.btnHome,
          ),
          NavigationDestination(
              icon: Icon(Icons.search),
              label: AppStrings.btnSearch
          ),
          NavigationDestination(
              icon: Icon(Icons.add_box_outlined),
              label: AppStrings.btnAdd,
          ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: AppStrings.btnProfile,
        ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints){
          return const Center(
            child: Text("MAIN STRANICA"),
          );
        },
      ),
    );
  }
}
