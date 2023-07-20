import 'dart:async';

import 'package:flutter/material.dart';
import 'package:remove_bg/utills/string.dart';
import 'package:remove_bg/view/home_screen.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: SizeTransition(
          sizeFactor: _fadeAnimation,
          child: Column(
            key: const ValueKey<int>(1),
            children: [
              Expanded(
                flex: 2,
                child: Image.asset("assets/images/cup.png"),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(127, 76, 153, 1),
                        Color.fromRGBO(56, 52, 58, 1)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      const Positioned(
                        top: -50,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 40,
                          child: Text(
                            "Logo",
                            style: TextStyle(
                              color: Color.fromRGBO(127, 76, 153, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: const [
                          SizedBox(height: 30,),
                          Text(
                            welcome,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                            ),
                          ),
                          Text(
                            toApp,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
