// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firstapp/main.dart';
// import 'package:firstapp/screens/ProfileScreen.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:firstapp/services/api.dart';
// import 'package:firstapp/pages/home_page.dart';
//
// import '../providers/user_provider.dart';
// class googleSignIn extends StatefulWidget {
//   const googleSignIn({super.key});
//
//   @override
//   State<googleSignIn> createState() => _googleSignInState();
// }
//
// class _googleSignInState extends State<googleSignIn> {
//   final  _usernameController= TextEditingController();
//   @override
//   void initState() {
//     _setupAuthListener();
//
//
//     super.initState();
//   }
// final supabase=Supabase.instance.client;
//   void _setupAuthListener() {
//     supabase.auth.onAuthStateChange.listen((data) {
//       final event = data.event;
//       if (event == AuthChangeEvent.signedIn) {
//          _Googlelogin();
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
//
//     return supabase.auth.signInWithIdToken(
//       provider: OAuthProvider.google,
//       idToken: idToken,
//       accessToken: accessToken,
//     );
//   }
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   return Scaffold(
//   //     appBar: AppBar(
//   //       title: const Text('Login'),
//   //     ),
//   //     body: Center(
//   //       child: ElevatedButton(
//   //         onPressed: _googleSignIn,
//   //         child: const Text('Google login'),
//   //       ),
//   //     ),
//   //   );
//   // }
//   @override
//   void dispose() {
//     _usernameController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               TextField(
//                 controller: _usernameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Fullname',
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _googleSignIn,
//                 child: const Text('Google login'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
//   Future<void> _Googlelogin() async {
//     userProvider userP = Provider.of<userProvider>(context);
//     final user = supabase.auth.currentUser;
//     final String fullname=_usernameController.text.trim();
//     userP.Fullname=fullname;
//     userP.email=user!.userMetadata?['email'];
//     userP.userId=user.id;
//
//
//     String profileImageBase64 = base64Encode(user!.userMetadata?['avatar_url']!);
//     Uint8List profileImageBytes = Uint8List(0);
//     Api api = Api();
//     api. postChangeUser(fullname,profileImageBase64,user!.id).then((response){
//       if (response['error'] != null) {
//
//         print('An error occurred: ${response['error']}');
//       } else {
//         print('Username added successfully');
//         userP.role=response['data']['user']['role']?? 'Unknown';
//         bool isBase64(String input) {
//           final RegExp base64 = RegExp(
//             r'^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$',
//           );
//           return base64.hasMatch(input);
//         }
//
//         if (isBase64(profileImageBase64)) {
//
//           try {
//             profileImageBytes = base64Decode(profileImageBase64);
//           } catch (e) {
//             print('Error decoding Base64: $e');
//           }
//         } else {
//           print('Invalid Base64 string: $profileImageBase64');
//         }
//         userP.profileimage=profileImageBytes;
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => HomePage(
//
//           )),
//         );
//       }
//     });
//
//
//     print('signup successful');
//
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



//
//
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
//
//   @override
//   void initState() {
//     super.initState();
//     _googleSignIn(); // Initiate Google Sign-In immediately
//   }
//
//   void _setupAuthListener() {
//     supabase.auth.onAuthStateChange.listen((data) {
//       final event = data.event;
//       if (event == AuthChangeEvent.signedIn) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => ProfileScreen(),
//           ),
//         );
//       }
//     });
//   }
//
//   Future<void> _googleSignIn() async {
//     // TODO: Update with your actual Web Client ID obtained from Google Developer Console
//     const webClientId = '996897743188-1pofp20d27p2c9kdlr7hj082m3a80p7s.apps.googleusercontent.com';
//
//     final GoogleSignIn googleSignIn = GoogleSignIn(
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
//         child: CircularProgressIndicator(), // Placeholder for loading indicator
//       ),
//     );
//   }
//
//
//
//
//
//
//
//   Future<void> _Googlelogin() async {
//     final user = supabase.auth.currentUser;
//
//
//     Api api = Api();
//     api. getUser(user!.id).then((response){
//       if (response['error'] != null) {
//
//         print('An error occurred: ${response['error']}');
//       } else {
//         print('Username added successfully');
//         String fullName = response['data']['user']['fullName']?? 'Unknown';
//         String userEmail = user.userMetadata?['email'];
//         String UserId=user.id;
//         String role=response['data']['user']['role']?? 'Unknown';
//         String  profileImage=response['data']['user']['profileImage']?? 'Unknown';
//         Uint8List profileImageBytes = Uint8List(0);
//
//         bool isBase64(String input) {
//           final RegExp base64 = RegExp(
//             r'^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$',
//           );
//           return base64.hasMatch(input);
//         }
//
//         if (isBase64(profileImage)) {
//
//           try {
//             profileImageBytes = base64Decode(profileImage);
//           } catch (e) {
//             print('Error decoding Base64: $e');
//           }
//         } else {
//           print('Invalid Base64 string: $profileImage');
//         }
//
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => HomePage(
//             userName:  fullName,
//             userEmail: userEmail,
//             userId:UserId,
//             role:role,
//             profileImage: profileImageBytes,
//           )),
//         );
//       }
//     });
//
//
//     print('signup successful');
//
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firstapp/services/api.dart';
import 'package:firstapp/pages/home_page.dart';

import '../providers/user_provider.dart';

class GoogleSignInPage extends StatefulWidget {
  const GoogleSignInPage({super.key});

  @override
  State<GoogleSignInPage> createState() => _GoogleSignInPageState();
}

class _GoogleSignInPageState extends State<GoogleSignInPage> {
  final _usernameController = TextEditingController();
  bool _isButtonDisabled = true;
  bool _showValidationMessage = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_checkIfButtonShouldBeEnabled);
    _setupAuthListener();
  }

  final supabase = Supabase.instance.client;

  void _setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        _Googlelogin();
      }
    });
  }

  Future<AuthResponse> _googleSignIn() async {
    const webClientId = '996897743188-1pofp20d27p2c9kdlr7hj082m3a80p7s.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null || idToken == null) {
      throw 'No Access Token or ID Token found.';
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _checkIfButtonShouldBeEnabled() {
    setState(() {
      _isButtonDisabled = _usernameController.text.trim().isEmpty;
      _showValidationMessage = _isButtonDisabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Fullname',
                ),
              ),
              if (_showValidationMessage)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Please provide your full name.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isButtonDisabled ? null : _googleSignIn,
                child: const Text('Google login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _Googlelogin() async {
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    final user = supabase.auth.currentUser;
    final String fullname = _usernameController.text.trim();
    userP.Fullname = fullname;
    userP.email = user!.userMetadata?['email'];
    userP.userId = user.id;

    String profileImageBase64 = base64Encode(user.userMetadata?['avatar_url']!);
    Uint8List profileImageBytes = Uint8List(0);
    Api api = Api();
    api.postChangeUser(fullname, profileImageBase64, user.id).then((response) {
      if (response['error'] != null) {
        print('An error occurred: ${response['error']}');
      } else {

        userP.role = response['data']['user']['role'] ?? 'Unknown';

        bool isBase64(String input) {
          final RegExp base64 = RegExp(
            r'^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$',
          );
          return base64.hasMatch(input);
        }

        if (isBase64(profileImageBase64)) {
          try {
            profileImageBytes = base64Decode(profileImageBase64);
          } catch (e) {
            print('Error decoding Base64: $e');
          }
        } else {
          print('Invalid Base64 string: $profileImageBase64');
        }
        userP.profileimage = profileImageBytes;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    });

    print('Signup successful');
  }
}
