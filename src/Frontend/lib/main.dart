import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firstapp/login_page.dart';

import 'package:flutter/material.dart';
import 'package:firstapp/signin_page.dart';
import 'package:firstapp/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.black),
      home: AnimatedSplashScreen(
        splash: Center(
          child: Text(
            'WhatsOn@UP',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        nextScreen: LoginPage(),
        splashTransition: SplashTransition.slideTransition,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
