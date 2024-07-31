
// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../main.dart';
//
// class ResetPasswordPage extends StatefulWidget {
//   final String? accessToken;
//
//   const ResetPasswordPage({Key? key, this.accessToken}) : super(key: key);
//
//   @override
//   _ResetPasswordPageState createState() => _ResetPasswordPageState();
// }
//
// class _ResetPasswordPageState extends State<ResetPasswordPage> {
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _isLoading = false;
//
//   @override
//   void dispose() {
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _resetPassword() async {
//     if (_passwordController.text != _confirmPasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Passwords do not match')),
//       );
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//     final password = _passwordController.text.trim();
//     try {
//       final response = await supabase.auth.updateUser(
//         UserAttributes(
//           password: password,
//         ),
//       );
//
//       if (response.user != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Password reset successful')),
//         );
//         Navigator.of(context).pushReplacementNamed('/login');
//       }
//     } on AuthException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.message)),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Error occurred, please try again')),
//       );
//     }
//
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Reset Password')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextFormField(
//               controller: _passwordController,
//               decoration: InputDecoration(
//                 labelText: 'New Password',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//               ),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             TextFormField(
//               controller: _confirmPasswordController,
//               decoration: InputDecoration(
//                 labelText: 'Confirm Password',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//               ),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isLoading ? null : _resetPassword,
//               child: _isLoading
//                   ? const CircularProgressIndicator()
//                   : const Text('Reset Password'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? accessToken;

  const ResetPasswordPage({super.key, this.accessToken});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    final password = _passwordController.text.trim();
    try {
      final response = await supabase.auth.updateUser(
        UserAttributes(
          password: password,
        ),
      );

      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successful')),
        );
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred, please try again')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
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
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              obscureText: _obscureConfirmPassword,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _resetPassword,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
