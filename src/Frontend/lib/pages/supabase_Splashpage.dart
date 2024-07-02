import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import '../main.dart';
import 'package:firstapp/pages/supabase_login.dart';



class  SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    _redirect();
  }
Future<void>_redirect() async{
  await Future.delayed(Duration(seconds: 2));
  final session = supabase.auth.currentSession;
  if(!mounted) return;
  if(session != null) {
    Navigator.of(context).pushReplacementNamed('/account');
  }
  else{
    Navigator.of(context).pushReplacementNamed('/login');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  AnimatedSplashScreen(
    splash: const Center(
    child: Text(
      'WhatsOn@UP',
      style: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
      ),
    ),
    ),
    splashTransition: SplashTransition.slideTransition,
        nextScreen: SupabaseLogin(),
    ),
    );
  }
}



