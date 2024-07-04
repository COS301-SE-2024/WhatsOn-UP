
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
class SupabaseAccountpage extends StatelessWidget {
  const SupabaseAccountpage({super.key});


  void _logout(BuildContext context) async {
    // Call Supabase signOut method to clear the session
    await supabase.auth.signOut();


    // Navigate to the login page
    Navigator.of(context).pushReplacementNamed('/login');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _logout(context),
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
