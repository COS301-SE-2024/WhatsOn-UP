import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firstapp/pages/home_page.dart';
import 'package:firstapp/pages/login_page.dart';
import 'package:firstapp/pages/rsvp_events_page.dart';
import 'package:firstapp/widgets/event_card_RSVP.dart';
import 'package:firstapp/widgets/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/pages/signin_page.dart';
import 'package:firstapp/screens/splash.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/pages/settings_page.dart';



void main() {
  // runApp(const MyApp());
  return runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => new ThemeNotifier(),
    child: MyApp(),
    ));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => MaterialApp(
        theme: theme.getTheme(),
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
      ),
    );
  }
}