import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UserManualWebView extends StatefulWidget {
  const UserManualWebView({Key? key}) : super(key: key);

  @override
  _UserManualWebViewState createState() => _UserManualWebViewState();
}

class _UserManualWebViewState extends State<UserManualWebView> {
  bool _isLoading = true;
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.disabled)
    ..loadRequest(Uri.parse('https://cos301-se-2024.github.io/WhatsOn-UP/'));

  @override
  void initState() {
    super.initState();
    controller.setNavigationDelegate(
      NavigationDelegate(
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
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
