// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firstapp/main.dart';
// import 'package:firstapp/screens/ProfileScreen.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// class googleSignIn extends StatefulWidget {
//   const googleSignIn({super.key});
//
//   @override
//   State<googleSignIn> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<googleSignIn> {
//   @override
//   void initState() {
//     _googleSignIn();
//
//
//     super.initState();
//   }
// final supabase=Supabase.instance.client;
//   void _setupAuthListener() {
//     supabase.auth.onAuthStateChange.listen((data) {
//       final event = data.event;
//       if (event == AuthChangeEvent.signedIn) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) =>  ProfileScreen(),
//           ),
//         );
//       }
//     });
//   }
//
//   Future<AuthResponse> _googleSignIn() async {
//     /// TODO: update the Web client ID with your own.
//     ///
//     /// Web Client ID that you registered with Google Cloud.
//     const webClientId = '996897743188-1pofp20d27p2c9kdlr7hj082m3a80p7s.apps.googleusercontent.com';
//
//     /// TODO: update the iOS client ID with your own.
//     ///
//     /// iOS Client ID that you registered with Google Cloud.
//     const iosClientId = 'my-ios.apps.googleusercontent.com';
//
//     // Google sign in on Android will work without providing the Android
//     // Client ID registered on Google Cloud.
//
//     final GoogleSignIn googleSignIn = GoogleSignIn(
//       // clientId: iosClientId,
//       serverClientId: webClientId,
//     );
//     final googleUser = await googleSignIn.signIn();
//     final googleAuth = await googleUser!.authentication;
//     final accessToken = googleAuth.accessToken;
//     final idToken = googleAuth.idToken;
//
//     if (accessToken == null) {
//       throw 'No Access Token found.';
//     }
//     if (idToken == null) {
//       throw 'No ID Token found.';
//     }
//     _setupAuthListener();
//     return supabase.auth.signInWithIdToken(
//       provider: OAuthProvider.google,
//       idToken: idToken,
//       accessToken: accessToken,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _googleSignIn,
//           child: const Text('Google login'),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firstapp/screens/ProfileScreen.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class GoogleSignInPage extends StatefulWidget {
//   const GoogleSignInPage({Key? key}) : super(key: key);
//
//   @override
//   State<GoogleSignInPage> createState() => _GoogleSignInPageState();
// }
//
// class _GoogleSignInPageState extends State<GoogleSignInPage> {
//   final supabase = Supabase.instance.client;
//   bool isAuthenticated = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _googleSignIn();
//   }
//
//   void _setupAuthListener() {
//     supabase.auth.onAuthStateChange.listen((data) {
//       final event = data.event;
//       if (event == AuthChangeEvent.signedIn) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) =>  ProfileScreen(),
//            ),
//          );
//       }
//     });
//   }
//
//   Future<void> _googleSignIn() async {
//     const webClientId = '996897743188-1pofp20d27p2c9kdlr7hj082m3a80p7s.apps.googleusercontent.com';
//
//     final GoogleSignIn googleSignIn = GoogleSignIn(
//       // clientId: 'YOUR_CLIENT_ID.apps.googleusercontent.com', // Replace with your Web Client ID
//       serverClientId: webClientId,
//     );
//
//     try {
//       final googleUser = await googleSignIn.signIn();
//       if (googleUser == null) {
//         throw 'Google sign in aborted.';
//       }
//
//       final googleAuth = await googleUser.authentication;
//       final accessToken = googleAuth.accessToken;
//       final idToken = googleAuth.idToken;
//
//       if (accessToken == null || idToken == null) {
//         throw 'Missing Google Auth Token';
//       }
//
//       await supabase.auth.signInWithIdToken(
//         provider: OAuthProvider.google,
//         idToken: idToken,
//         accessToken: accessToken,
//       );
//
//       _setupAuthListener();
//     } catch (error) {
//       print('Google login failed: $error');
//       // Handle error here
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//       body: Center(
//         child: isAuthenticated
//             ? const CircularProgressIndicator() // Placeholder for loading indicator
//             : ElevatedButton(
//           onPressed: _googleSignIn,
//           child: const Text('Google login'),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firstapp/screens/ProfileScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleSignInPage extends StatefulWidget {
  const GoogleSignInPage({Key? key}) : super(key: key);

  @override
  State<GoogleSignInPage> createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _googleSignIn(); // Initiate Google Sign-In immediately
  }

  void _setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ),
        );
      }
    });
  }

  Future<void> _googleSignIn() async {
    // TODO: Update with your actual Web Client ID obtained from Google Developer Console
    const webClientId = '996897743188-1pofp20d27p2c9kdlr7hj082m3a80p7s.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: webClientId,
    );

    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw 'Google sign in aborted.';
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw 'Missing Google Auth Token';
      }

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      _setupAuthListener();
    } catch (error) {
      print('Google login failed: $error');
      // Handle error here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: CircularProgressIndicator(), // Placeholder for loading indicator
      ),
    );
  }
}