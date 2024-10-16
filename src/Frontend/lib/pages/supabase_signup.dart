import 'dart:async';
import 'package:firstapp/providers/events_providers.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import 'package:firstapp/services/api.dart';
import '../providers/events_providers.dart';
import '../providers/notification_providers.dart';
import '../surveys/SurveyChooseCat_screen.dart';
import '../services/socket_client.dart';
import '../services/globals.dart' as globals;


class SupabaseSignup extends StatefulWidget {
  const SupabaseSignup({super.key});

  @override
  State<SupabaseSignup> createState() => _SupabaseSignupState();
}

class _SupabaseSignupState extends State<SupabaseSignup> {
  final _emailController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  late final StreamSubscription<AuthState> _authSubscription;
  late Color myColor;
  late Size mediaSize;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullnameController.dispose();
    _confirmPasswordController.dispose();
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
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
      height: mediaSize.height * 0.6,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
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
          const SizedBox(height: 30),
          TextFormField(
            controller: _fullnameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
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
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final email = _emailController.text.trim();
              final password = _passwordController.text.trim();
              final confirmPassword = _confirmPasswordController.text.trim();

              if (password != confirmPassword) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Passwords do not match"),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
                return;
              }

              try {
                final AuthResponse res = await supabase.auth
                    .signUp(email: email, password: password);
                if (mounted) {
                  // print("CALLING USERNAME INPUT");
                  Provider.of<userProvider>(context, listen: false).JWT =
                      supabase.auth.currentSession!.accessToken;

                  await _usernameInput(); // Ensure the username is saved
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Signed up successfully"),
                        backgroundColor: Colors.green,));
                }
              } on AuthException catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(error.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ));
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Error occurred, please try again'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ));
              }
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }

  Future<void> _usernameInput() async {
    final user = supabase.auth.currentUser;
    String name = _fullnameController.text;
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    EventProvider eventP = Provider.of<EventProvider>(context, listen: false);
    Api api = Api();

    api.postUsername(name, userP.JWT).then((response) {
      if (response['error'] != null) {
        print('An error occurred: ${response['error']}');
      } else {
        String userEmail = user!.userMetadata?['email'];
        userP.userId = user.id;
        userP.Fullname = name;
        userP.email = userEmail;
        userP.role = response['data']['user']['role'] ?? 'Unknown';
        userP.profileImage = response['data']['user']['profileImage'] ?? 'Unknown';
        
        eventP.refreshEvents(userP.JWT);
        eventP.refreshRecommendations(userP.JWT);
        
        notificationProvider _notificationProvider =
            Provider.of<notificationProvider>(context, listen: false);
        _notificationProvider.refreshNotifications(userP.JWT);
        
        SocketService('https://${globals.liveNotificationService}', _notificationProvider, userP.JWT, context);
        userP.Generalusers(userP.JWT);
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SurveyScreen()),
        );
      }
    });
  }
}