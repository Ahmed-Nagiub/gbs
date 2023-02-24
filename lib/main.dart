import 'package:flutter/material.dart';
import 'package:gbs_app/ui/home.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: homeScreen.routeName,
      routes: {
        homeScreen.routeName : (c)=> homeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

