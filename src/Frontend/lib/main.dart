import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firstapp/pages/home_page.dart';
import 'package:firstapp/pages/login_page.dart';
import 'package:firstapp/pages/rsvp_events_page.dart';
import 'package:firstapp/widgets/event_card_RSVP.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/pages/signin_page.dart';
import 'package:firstapp/screens/splash.dart';

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
        splash: const Center(
          child: Text(
            'WhatsOn@UP',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        nextScreen: const LoginPage(),
        splashTransition: SplashTransition.slideTransition,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
