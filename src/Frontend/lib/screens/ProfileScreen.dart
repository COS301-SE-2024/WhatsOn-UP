import 'package:flutter/material.dart';
import 'package:firstapp/main.dart';
import 'package:firstapp/pages/google_signin.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'dart:convert';



//just testing

Uint8List decodeProfileImage(String profileImage) {
  Uint8List profileImageBytes = Uint8List(0);

  bool isBase64(String input) {
    final RegExp base64 = RegExp(
      r'^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$',
    );
    return base64.hasMatch(input);
  }

  if (isBase64(profileImage)) {
    try {
      profileImageBytes = base64Decode(profileImage);
    } catch (e) {
      print('Error decoding Base64: $e');
    }
  } else {
    print('Invalid Base64 string: $profileImage');
  }

  return profileImageBytes;
}
class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final supabase=Supabase.instance.client;
  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final profileImageUrl = user?.userMetadata?['avatar_url'];
    final fullName = user?.userMetadata?['full_name'];
    final email=user?.userMetadata?['email'];
    final role=user?.userMetadata?['role'];
    final id=user?.userMetadata?['id'];
    print ('this is your id: ');
    print(user?.id);
    Uint8List profileImageBytes = Uint8List(0);

    if (profileImageUrl != null) {
      profileImageBytes = decodeProfileImage(profileImageUrl);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('access the google user '),
        actions: [
          TextButton(
            onPressed: () async {
              await supabase.auth.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const GoogleSignInPage() ),
                );
              }
            },
            child: const Text('Sign out'),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (profileImageUrl != null)
              ClipOval(
                child: Image.network(
                  profileImageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              fullName ?? '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
