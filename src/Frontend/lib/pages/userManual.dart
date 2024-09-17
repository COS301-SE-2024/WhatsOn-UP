import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserManualWebView extends StatefulWidget {
  const UserManualWebView({Key? key}) : super(key: key);

  @override
  _UserManualWebViewState createState() => _UserManualWebViewState();
}

class _UserManualWebViewState extends State<UserManualWebView> {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  bool _isLoading = true;
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.disabled)
    ..loadRequest(Uri.parse('https://cos301-se-2024.github.io/WhatsOn-UP/'));

  @override
  void initState() {
    super.initState();

    final user = Supabase.instance.client.auth.currentUser;
    final userId = user?.id;


    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) async {
          await _analytics.logEvent(
         name: 'user_manual_opened',
            parameters: {
              'url': url,
              'user_id': userId.toString(),
            },
      );
    },
        onPageFinished: (url) {
          setState(() {
            _isLoading = false;
          });

        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Manual'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (_isLoading)
            Center(
              child: SpinKitPianoWave(
                color: Color.fromARGB(255, 149, 137, 74),
                size: 50.0,
              ),
            ),
        ],
      ),
    );
  }
}
