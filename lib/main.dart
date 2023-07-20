import 'package:flutter/material.dart';
import 'package:remove_bg/utills/string.dart';
import 'package:remove_bg/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
     home: const SplashScreen(),
    );
  }
}

