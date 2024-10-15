// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:firstapp/services/api.dart';
// import 'package:firstapp/pages/home_page.dart';
//
// import '../providers/user_provider.dart';
//
// class GoogleSignInPage extends StatefulWidget {
//   const GoogleSignInPage({super.key});
//
//   @override
//   State<GoogleSignInPage> createState() => _GoogleSignInPageState();
// }
//
// class _GoogleSignInPageState extends State<GoogleSignInPage> {
//   final _usernameController = TextEditingController();
//   bool _isButtonDisabled = true;
//   bool _showValidationMessage = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _usernameController.addListener(_checkIfButtonShouldBeEnabled);
//     _setupAuthListener();
//   }
//
//   final supabase = Supabase.instance.client;
//
//   void _setupAuthListener() {
//     supabase.auth.onAuthStateChange.listen((data) {
//       final event = data.event;
//       if (event == AuthChangeEvent.signedIn) {
//         _Googlelogin();
//       }
//     });
//   }
//
//   Future<AuthResponse> _nativegoogleSignIn() async {
//     const webClientId =
//         '1035006743185-gr6hljjbr20k7sedcpsvgl180h2s8vtp.apps.googleusercontent.com';
//
//     final GoogleSignIn googleSignIn = GoogleSignIn(
//       serverClientId: webClientId,
//     );
//     final googleUser = await googleSignIn.signIn();
//     final googleAuth = await googleUser!.authentication;
//     final accessToken = googleAuth.accessToken;
//     final idToken = googleAuth.idToken;
//
//     if (accessToken == null || idToken == null) {
//       throw 'No Access Token or ID Token found.';
//     }
//
//     await supabase.auth.signInWithIdToken(
//       provider: OAuthProvider.google,
//       idToken: idToken,
//       accessToken: accessToken,
//     );
//   }
//
//   @override
//   void dispose() {
//     _usernameController.dispose();
//     super.dispose();
//   }
//
//   void _checkIfButtonShouldBeEnabled() {
//     setState(() {
//       _isButtonDisabled = _usernameController.text.trim().isEmpty;
//       _showValidationMessage = _isButtonDisabled;
//     });
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
//               if (_showValidationMessage)
//                 const Padding(
//                   padding: EdgeInsets.only(top: 8.0),
//                   child: Text(
//                     'Please provide your full name.',
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async{
//                   if(!kIsWeb && (Platform.isAndroid))
//                    await _nativegoogleSignIn();
//
//                 }
//                 await supabase.auth.signInWithOAuth(OAuthProvider.google);
//                 },
//
//                 ), child: const Text('Sign in with Google'),;
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _Googlelogin() async {
//     userProvider userP = Provider.of<userProvider>(context, listen: false);
//     final user = supabase.auth.currentUser;
//     final String fullname = _usernameController.text.trim();
//     userP.Fullname = fullname;
//     userP.email = user!.userMetadata?['email'];
//     userP.userId = user.id;
//
//     Api api = Api();
//     api.postChangeUser(fullname, user.id).then((response) {
//       if (response['error'] != null) {
//         print('An error occurred: ${response['error']}');
//       } else {
//         userP.role = response['data']['user']['role'] ?? 'Unknown';
//
//         userP.profileImage = user.userMetadata?['avatar_url'];
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => HomePage()),
//         );
//       }
//     });
//
//     print('Signup successful');
//   }
// }
// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:firstapp/pages/home_page.dart';
//
// import '../providers/user_provider.dart';
// import '../services/api.dart';
//
// class GoogleSignInPage extends StatefulWidget {
//   const GoogleSignInPage({super.key});
//
//   @override
//   State<GoogleSignInPage> createState() => _GoogleSignInPageState();
// }
//
// class _GoogleSignInPageState extends State<GoogleSignInPage> {
//   final _usernameController = TextEditingController();
//   bool _isButtonDisabled = true;
//   bool _showValidationMessage = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _usernameController.addListener(_checkIfButtonShouldBeEnabled);
//     _setupAuthListener();
//   }
//
//   final supabase = Supabase.instance.client;
//
//   void _setupAuthListener() {
//     supabase.auth.onAuthStateChange.listen((data) {
//       final event = data.event;
//       if (event == AuthChangeEvent.signedIn) {
//         print('User signed in!');
//         // _Googlelogin();
//       }
//     });
//   }
//
//   Future<void> _nativeGoogleSignIn() async {
//     const webClientId =
//         '1035006743185-gr6hljjbr20k7sedcpsvgl180h2s8vtp.apps.googleusercontent.com';
//
//     final GoogleSignIn googleSignIn = GoogleSignIn(
//       serverClientId: webClientId,
//     );
//     try {
//       final googleUser = await googleSignIn.signIn();
//       final googleAuth = await googleUser!.authentication;
//       final accessToken = googleAuth.accessToken;
//       final idToken = googleAuth.idToken;
//
//       if (accessToken == null || idToken == null) {
//         throw 'No Access Token or ID Token found.';
//       }
//
//       await supabase.auth.signInWithIdToken(
//         provider: OAuthProvider.google,
//         idToken: idToken,
//         accessToken: accessToken,
//       );
//     } catch (error) {
//       // Handle errors here
//       print('Error during Google Sign-In: $error');
//     }
//   }
//
//   @override
//   void dispose() {
//     _usernameController.dispose();
//     super.dispose();
//   }
//
//   void _checkIfButtonShouldBeEnabled() {
//     setState(() {
//       _isButtonDisabled = _usernameController.text.trim().isEmpty;
//       _showValidationMessage = _isButtonDisabled;
//     });
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
//               if (_showValidationMessage)
//                 const Padding(
//                   padding: EdgeInsets.only(top: 8.0),
//                   child: Text(
//                     'Please provide your full name.',
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _isButtonDisabled
//                     ? null
//                     : () async {
//                   if (!kIsWeb && Platform.isAndroid) {
//                     // await _nativeGoogleSignIn();
//                     try{
//                       await supabase.auth.signInWithOAuth(OAuthProvider.google);
//                     }
//                     catch(error){
//                       print('ERROR SIGNING IN WITH GOOGLE ${error}');
//                     }
//                   } else {
//                     await supabase.auth.signInWithOAuth(OAuthProvider.google);
//                   }
//                 },
//                 child: const Text('Sign in with Google'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _Googlelogin() async {
//     final userProvider userP = Provider.of<userProvider>(context, listen: false);
//     final user = supabase.auth.currentUser;
//     final String fullname = _usernameController.text.trim();
//     userP.Fullname = fullname;
//     userP.email = user!.userMetadata?['email'];
//     userP.userId = user.id;
//
//     final api = Api();
//     try {
//       final response = await api.postChangeUser(fullname, userP.JWT);
//       if (response['error'] != null) {
//         print('An error occurred: ${response['error']}');
//       } else {
//         userP.role = response['data']['user']['role'] ?? 'Unknown';
//         userP.profileImage = user.userMetadata?['avatar_url'];
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => HomePage()),
//         );
//       }
//     } catch (error) {
//       print('Error during API call: $error');
//     }
//
//     print('Signup successful');
//   }
// }

