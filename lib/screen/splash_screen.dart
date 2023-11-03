import 'dart:async';

import 'package:flutter/material.dart';
import 'package:piano_tiles/screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 10), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 450,
              width: 350,
              child: Image.asset("assets/logo.png"),
            ),
          ),
          const Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Column(
              children: [
                Icon(
                  Icons.headset_mic,
                  size: 40,
                  color: Colors.blue,
                ),
                Text(
                  "Headphone recommended",
                  style: TextStyle(color: Colors.blue, fontSize: 22),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
