import 'package:flutter/material.dart';
import '../main.dart';

class SupabaseAccountpage extends StatelessWidget {
  const SupabaseAccountpage({super.key});

  void _logout(BuildContext context) async {
    await supabase.auth.signOut();

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
