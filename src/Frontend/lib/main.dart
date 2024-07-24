// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:firstapp/pages/home_page.dart';
// import 'package:firstapp/pages/login_page.dart';
// import 'package:firstapp/pages/rsvp_events_page.dart';
// import 'package:firstapp/widgets/event_card_RSVP.dart';
// import 'package:firstapp/widgets/theme_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:firstapp/pages/signin_page.dart';
// import 'package:firstapp/screens/splash.dart';
// import 'package:provider/provider.dart';
// import 'package:firstapp/pages/settings_page.dart';
// import 'package:firstapp/screens/SearchScreen.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:supabase_auth_ui/supabase_auth_ui.dart';
// void main() async{
//   // runApp(const MyApp());
//   // WidgetsFlutterBinding.ensureInitialized();
//   await Supabase.initialize(
//     url: 'https://mehgbhiirnmypfgnkaud.supabase.co',
//     anonKey:'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1laGdiaGlpcm5teXBmZ25rYXVkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTY3ODcxMjMsImV4cCI6MjAzMjM2MzEyM30.IqwbTqO7T_ZyYjkWBAbKCK2kwEzJktZtAEJKlrfjYvY',
//
//   );
//    runApp(ChangeNotifierProvider<ThemeNotifier>(
//     create: (_) => new ThemeNotifier(),
//     child: MyApp(),
//     ));
// }
// final supabase = Supabase.instance.client;
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeNotifier>(
//       builder: (context, theme, _) => MaterialApp(
//         theme: theme.getTheme(),
//         home: AnimatedSplashScreen(
//         splash: const Center(
//           child: Text(
//             'WhatsOn@UP',
//             style: TextStyle(
//               fontSize: 50,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//           nextScreen:  const LoginPage(),
//
//         splashTransition: SplashTransition.slideTransition,
//       ),
//       debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }



import 'package:firstapp/pages/editProfile_page.dart';

import 'package:firstapp/pages/home_page.dart';
import 'package:firstapp/pages/profilePage.dart';
import 'package:firstapp/pages/settings_page.dart';
import 'package:firstapp/pages/supabase_Accountpage.dart';
import 'package:firstapp/pages/supabase_Splashpage.dart';
import 'package:firstapp/pages/supabase_login.dart';
import 'package:firstapp/pages/supabase_resetPassword.dart';
import 'package:firstapp/providers/events_providers.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/screens/SearchScreen.dart';
import 'package:firstapp/services/api.dart';
import 'package:firstapp/widgets/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
late SupabaseClient supabaseClient;
void main() async{
  var api = Api();
  await Supabase.initialize(
    url: 'https://mehgbhiirnmypfgnkaud.supabase.co',
    anonKey:'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1laGdiaGlpcm5teXBmZ25rYXVkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTY3ODcxMjMsImV4cCI6MjAzMjM2MzEyM30.IqwbTqO7T_ZyYjkWBAbKCK2kwEzJktZtAEJKlrfjYvY',

  );
  // runApp(ChangeNotifierProvider<ThemeNotifier>(
  //   create: (_) => new ThemeNotifier(),
  //   child: MyApp(),
  // ));
  // runApp(
  //   ChangeNotifierProvider<ThemeNotifier>(
  //     create:(context)=> userProvider(),
  //      child:  MyApp(),
  //   ),
  // );

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => EventProvider(api: api)),
      ChangeNotifierProvider(create: (context) => userProvider()),
      ChangeNotifierProvider(create: (context) => ThemeNotifier()),
    ],
      child: MyApp(),
  ),
  );
}

final supabase = Supabase.instance.client;
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => MaterialApp(
        theme: theme.getTheme(),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/login': (context) => const SupabaseLogin(),
          '/account': (context) => const SupabaseAccountpage(),
          '/profile': (context)=> ProfilePage(),
          '/editProfile': (context)=>  EditprofilePage(),
          '/home': (context)=> const HomePage(),
          // '/rsvp': (context)=> const RSVPEventsPage(),
          '/settings': (context)=> const SettingsPage(),
          '/search': (context)=>  SearchScreen(),
           '/resetPassword': (context)=> const ResetPasswordPage(),
          //
        },

        debugShowCheckedModeBanner: false,
      ),

    );
  }
}