import 'dart:async';
import 'package:firstapp/pages/supabase_forgot_password.dart';
import 'package:firstapp/pages/supabase_signup.dart';
import 'package:flutter/foundation.dart';
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
  bool isLoading = false;


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  myColor = Theme.of(context).primaryColor;
  MediaQueryData mediaQuery = MediaQuery.of(context);
  mediaSize = kIsWeb ? Size(412.0, mediaQuery.size.height) : mediaQuery.size;
  
  // Wrap everything in Center to ensure width restriction is respected on the web
  return Center(
    child: Container(
      width: mediaSize.width, // Respect width limitation on web
      color: const Color.fromARGB(255, 149, 137, 74),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(top: 80, child: _buildTop()), // 40
            Positioned(bottom: 0, child: _buildBottom(context)),
          ],
        ),
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
        //   SizedBox(
        //   width: 200, 
        //   height: 200,
        //   child: const Image(
        //     image: AssetImage('images/whatsonupLogo.png'),
        //     fit: BoxFit.contain,
        //   ),
        // ),
        ],
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final googleButtonBackground = theme.brightness == Brightness.dark ? const Color.fromARGB(255, 20, 20, 20) : Colors.white;
    final googleButtonTextColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return Container(
      width: mediaSize.width,
      height: mediaSize.height * 0.7,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // color: Colors.white,
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
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
          Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForgotPass()),
              );
            },
            child: const Text('Forgot password?'),
          ),
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

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text("Logged In: ${authResponse.user!.email!}"),backgroundColor: Colors.green));


                  Provider.of<userProvider>(context, listen: false).JWT = 
                    supabase.auth.currentSession!.accessToken;
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
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white,)
                : const Text('Login'),
          ),
          const SizedBox(height: 10),
          TextButton(
          // ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SupabaseSignup()),
                );
              },

              child: const Text('Don\'t have an account? Sign Up')),
          // const SizedBox(height: 10),
          // const SizedBox(height: 20),
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const GoogleSignInPage()),
          //     );
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: googleButtonBackground,
          //     foregroundColor: googleButtonTextColor,
          //     side: const BorderSide(color: Colors.grey, width: 1.0),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(20.0),
          //     ),
          //     padding: const EdgeInsets.symmetric(vertical: 12.0),
          //     textStyle: const TextStyle(fontSize: 16),
          //   ),
          //   child: const Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Image(
          //         width: 24,
          //         height: 24,
          //         image: Svg('assets/images/google-icon.svg'),
          //       ),
          //       SizedBox(width: 8),
          //       Text('Sign in with Google'),
          //     ],
          //   ),
          // ),

          const SizedBox(height: 20),
          TextButton(
            onPressed: () async {
              try {
                await _login(isGuest: true);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
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
      eventP.refreshEvents('');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
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
          setState(() {
            isLoading = true;
          });


          final response = await api.getUser(userP.JWT!);
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

             api.JWT=userP.JWT;

             await eventP.refreshEvents(userP.JWT);

            await eventP.refreshRecommendations(userP.JWT);
            notificationProvider _notificationProvider =
                Provider.of<notificationProvider>(context, listen: false);
             // eventP.refreshSavedEvents(userP.JWT);
            _notificationProvider.refreshNotifications(userP.JWT);
            SocketService('https://${globals.liveNotificationService}',
                _notificationProvider, userP.JWT, context);
            userP.Generalusers(userP.JWT);

            userP.setUserData(
              userId: user.id,
              fullName: fullName,
              email: userEmail,
              role: role,
              profileImage: profileImage,
              isGuest: false,
            );

            setState(() {
              isLoading = false;
            });

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        } catch (e) {
          print('Error getting user data: $e');
        }

      }
    }
  }
}