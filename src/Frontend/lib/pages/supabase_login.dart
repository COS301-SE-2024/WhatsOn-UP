// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// import '../main.dart';
//
// class SupabaseLogin extends StatefulWidget {
//   const SupabaseLogin({super.key});
//   @override
//   State<SupabaseLogin> createState() => _SupabaseLoginState();
// }
//
// class _SupabaseLoginState extends State<SupabaseLogin> {
//   final _emailController = TextEditingController();
//
//   late final StreamSubscription<AuthState> _authSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     _authSubscription = supabase.auth.onAuthStateChange.listen((event) {
//       final session = event.session;
//       if (session != null) {
//         Navigator.of(context).pushReplacementNamed('/account');
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _authSubscription.cancel();
//     super.dispose();
//   }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//       appBar: AppBar(
//         title: const Text('login'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(12),
//         children: [
//           TextFormField(
//             controller: _emailController,
//             decoration: const InputDecoration(labelText: 'Email'),
//           ),
//
//           SizedBox(height: 12),
//           ElevatedButton(
//             onPressed: () async {
//               try {
//                 final email = _emailController.text.trim();
//                 await supabase.auth.signInWithOtp(
//                   email: email,
//                   emailRedirectTo:
//                       'io.supabase.flutterquickstart://login-callback/',
//
//                 );
//
//                 if (mounted) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Check your inbox')));
//                 }
//               } on AuthException catch (error) {
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   content: Text(error.message),
//                   backgroundColor: Theme.of(context).colorScheme.error,
//                 ));
//               } catch (error) {
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                   content: Text('Error occured please try again '),
//                   backgroundColor: Theme.of(context).colorScheme.error,
//                 ));
//               }
//
//               // final password = _passwordController.text;
//               // final response = await supabase.auth.signIn(email: email, password: password);
//               // if (response.error != null) {
//               //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               //     content: Text('Error: ${response.error!.message}'),
//               //   ));
//               // }
//             },
//             child: const Text('Login'),
//           ),
//         ],
//       ));
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('WhatON@UP'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const SizedBox(height: 50),
//             const Text(
//               'Welcome to WhatON@UP',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextFormField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   final email = _emailController.text.trim();
//                   await supabase.auth.signInWithOtp(
//                     email: email,
//                     emailRedirectTo:
//                     'io.supabase.flutterquickstart://login-callback/',
//                   );
//
//                   if (mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Check your inbox')));
//                   }
//                 } on AuthException catch (error) {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text(error.message),
//                     backgroundColor: Theme.of(context).colorScheme.error,
//                   ));
//                 } catch (error) {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text('Error occurred, please try again'),
//                     backgroundColor: Theme.of(context).colorScheme.error,
//                   ));
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16.0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//               ),
//               child: const Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:firstapp/pages/supabase_forgot_password.dart';
import 'package:firstapp/pages/supabase_signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:firstapp/pages/google_signin.dart';
import 'package:firstapp/pages/home_page.dart';
import 'package:firstapp/services/api.dart';
import '../providers/events_providers.dart';
import '../providers/notification_providers.dart';
import '../providers/user_provider.dart';
import '../services/socket_client.dart';
import '../services/globals.dart' as globals;

class SupabaseLogin extends StatefulWidget {
  const SupabaseLogin({super.key});

  @override
  State<SupabaseLogin> createState() => _SupabaseLoginState();
}

class _SupabaseLoginState extends State<SupabaseLogin> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();
  late final StreamSubscription<AuthState> _authSubscription;
  late Color myColor;
  late Size mediaSize;
  bool _obscurePassword = true;


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      color: const Color.fromARGB(255, 149, 137, 74),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(top: 80, child: _buildTop()),
            Positioned(bottom: 0, child: _buildBottom(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'WhatsOn@UP',
            style: TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Container(
      width: mediaSize.width,
      height: mediaSize.height * 0.7,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // color: Colors.white,
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            obscureText: _obscurePassword,
          ),
          const SizedBox(height: 20),
          // TextButton(
          ElevatedButton(
            onPressed: () async {
              try {
                final email = _emailController.text.trim();
                final password = _passwordController.text.trim();
                // await supabase.auth.signInWithOtp(
                //   email: email,
                //   emailRedirectTo:
                //   'io.supabase.flutterquickstart://login-callback/',
                // );
                final authResponse = await supabase.auth
                    .signInWithPassword(password: password, email: email);

                //for reset password workd
                //  await supabase.auth.resetPasswordForEmail(email,
                //    redirectTo: 'io.supabase.flutterquickstart://login-callback/',
                //  );

                //update password
                //  await supabase.auth.updateUser({
                //    password: password,
                //  } as UserAttributes);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text("Logged In: ${authResponse.user!.email!}")));
                  await _login();
                }
              } on AuthException catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(error.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ));
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Error occurred, please try again : $error'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ));
              }
            },

            child: const Text('Login'),
          ),
          const SizedBox(height: 10),
          // TextButton(
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SupabaseSignup()),
                );
              },

              child: Text('Sign Up')),
          const SizedBox(height: 10),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForgotPass()),
                );
              },
              child: Text('I forgot my password')),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Image(
                  width: 32,
                  height: 32,
                  image: Svg('assets/images/google-icon.svg'),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GoogleSignInPage()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () async {
              try {
                await _login(isGuest: true);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error logging in as guest: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: Colors.transparent,
            ),
            child: const Text('Log in as guest'),
          ),
        ],
      ),
    );
  }

  Future<void> _login({bool isGuest = false}) async {
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    EventProvider eventP = Provider.of<EventProvider>(context, listen: false);

    if (isGuest) {
      userP.setGuestUser();
      // eventP.fetchfortheFirstTimeRsvp('guest');
      // Skip getting events
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      final user = supabase.auth.currentUser;


      if (user != null) {
        final session = supabase.auth.currentSession;
        if (session != null) {
          print('JWT Token: ${session.accessToken}');
        }

        Api api = Api();
        try {
          final response = await api.getUser(user.id);
          if (response['error'] != null) {
            print('An error occurred: ${response['error']}');
          } else {
            String fullName = response['data']['user']['fullName'] ?? 'Unknown';
            String userEmail = user.userMetadata?['email'];
            String UserId = user.id;
            String role = response['data']['user']['role'] ?? 'Unknown';
            String profileImage =
                response['data']['user']['profileImage'] ?? 'Unknown';

            userP.userId = user.id;
            userP.Fullname = fullName;
            userP.email = userEmail;
            userP.role = role;
            userP.profileImage = profileImage;
            notificationProvider _notificationProvider =
                Provider.of<notificationProvider>(context, listen: false);
             eventP.refreshSavedEvents(userP.userId);
            _notificationProvider.refreshNotifications(userP.userId);
            SocketService('http://${globals.domain}:8082',
                _notificationProvider, userP.userId, context);
            userP.Generalusers(userP.userId);

            userP.setUserData(
              userId: user.id,
              fullName: fullName,
              email: userEmail,
              role: role,
              profileImage: profileImage,
              isGuest: false,
            );

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        } catch (e) {
          print('Error getting user data: $e');
        }
        print('signup successful');
      }
    }
  }
}
