import 'dart:async';
import 'package:firstapp/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import 'package:firstapp/services/api.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firstapp/pages/home_page.dart';

import '../providers/notification_providers.dart';
class SupabaseSignup extends StatefulWidget {
  const SupabaseSignup({super.key});

  @override
  State<SupabaseSignup> createState() => _SupabaseSignupState();
}

class _SupabaseSignupState extends State<SupabaseSignup> {
  final _emailController = TextEditingController();
  final _usernameController= TextEditingController();
  final _passwordController= TextEditingController();
  late final StreamSubscription<AuthState> _authSubscription;
  late Color myColor;
  late Size mediaSize;

  @override
  void initState() {
    super.initState();
    _authSubscription = supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      color: const Color.fromARGB(255, 149, 137, 74),
      child: Scaffold(
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
            Positioned(bottom: 3, child: _buildBottom()),
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

  Widget _buildBottom() {
    return Container(
      width: mediaSize.width,
      height: mediaSize.height * 0.6,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
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
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Fullname',
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
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(

            onPressed: () async {
              try {
                final email = _emailController.text.trim();
                final password= _passwordController.text.trim();
                // await supabase.auth.signInWithOtp(
                //   email: email,
                //   emailRedirectTo:
                //   'io.supabase.flutterquickstart://login-callback/',
                // );
                final AuthResponse res = await supabase.auth.signUp(
                    email: email,
                    password: password
                );
                if (mounted) {
                  await _usernameInput(); // Ensure the username is saved
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Signed up successfully")));
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              } on AuthException catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(error.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ));
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Error occurred, please try again'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ));
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: Colors.black),
              ), // Text color
              backgroundColor: Colors.transparent,
            ),

            child: const Text('Sign Up'),

          ),

        ],
      ),
    );
  }


  Future<void> _usernameInput() async {
      final user = supabase.auth.currentUser;
      String username = _usernameController.text;
userProvider userP = Provider.of<userProvider>(context, listen: false);
      Api api = Api();
      api.postUsername(username,user!.id).then((response) {
        if (response['error'] != null) {

          print('An error occurred: ${response['error']}');
        } else {
          print('Username added successfully');
          String fullName = response['data']['user']['fullName']?? 'Unknown';
          String userEmail = user.userMetadata?['email'];
          String UserId=user.id;
          String role=response['data']['user']['role']?? 'Unknown';
          String  profileImage=response['data']['user']['profileImage']?? 'Unknown';
          Uint8List profileImageBytes = Uint8List(0);
          userP.userId=user.id;
          userP.Fullname=fullName;
          userP.email=userEmail;
          userP.role=role;
          notificationProvider _notificationProvider = Provider.of<notificationProvider>(context, listen: false);
          _notificationProvider.apiInstance=api;
          _notificationProvider.refreshNotifications(userP.userId);
          userP. Generalusers(userP.userId);


          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(

            )),
          );
        }
      });


      print('signup successful');

  }
}
