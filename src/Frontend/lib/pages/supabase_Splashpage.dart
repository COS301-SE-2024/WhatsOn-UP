import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'package:firstapp/pages/supabase_login.dart';

import '../providers/events_providers.dart';
import '../providers/notification_providers.dart';
import '../providers/user_provider.dart';
import '../services/api.dart';

import '../services/socket_client.dart';
import '../services/globals.dart' as globals;

class SplashPage extends StatefulWidget {
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

  Future<void> _redirect() async {
    await Future.delayed(Duration(seconds: 2));
    final session = supabase.auth.currentSession;
    if (!mounted) return;
    if (session != null) {

      await _login();
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
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

  Future<void> _login() async {
    userProvider userP = Provider.of<userProvider>(context, listen: false);

    EventProvider eventP = Provider.of<EventProvider>(context, listen: false);
    final user = supabase.auth.currentUser;


    Api api = Api();

    api.getUser(user!.id).then((response) {
      if (response['error'] != null) {
        print('An error occurred: ${response['error']}');
      } else {
        String fullName = response['data']['user']['fullName'] ?? 'Unknown';
        String userEmail = user.userMetadata?['email'];
        String UserId = user.id;
        String role = response['data']['user']['role'] ?? 'Unknown';
        String profileImage = response['data']['user']['profileImage'] ?? 'Unknown';

        userP.userId = user.id;
        userP.Fullname = fullName;
        userP.email = userEmail;
        userP.role = role;
        userP.profileImage = profileImage;
        eventP.refreshRecommendations(userP.userId);
        eventP.refreshSavedEvents(userP.userId);
        notificationProvider _notificationProvider =
        Provider.of<notificationProvider>(context, listen: false);
        _notificationProvider.refreshNotifications(userP.userId);
        SocketService('http://${globals.domain}:8082',_notificationProvider, userP.userId, context);
        userP.Generalusers(userP.userId);


        userP.profileimage = profileImage;

        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }
}
