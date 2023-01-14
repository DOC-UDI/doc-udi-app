import 'dart:async';
// import 'package:docudi/homescreen/sign_up_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(88, 147, 255, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png"),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
