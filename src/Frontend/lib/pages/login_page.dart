// import 'dart:convert';
//
// import 'package:firstapp/screens/ProfileScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg_provider/flutter_svg_provider.dart';
// import 'package:firstapp/pages/signin_page.dart';
// import 'package:firstapp/pages/home_page.dart';
// import 'package:firstapp/services/api.dart';
// import 'dart:typed_data';
// import 'package:firstapp/pages/google_signin.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
//
// class _LoginPageState extends State<LoginPage> {
//   late Color myColor;
//   late Size mediaSize;
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   bool rememberUser = false;
//   bool _isObscured = true;
// String? _userId;
//   final _formKey = GlobalKey<FormState>();
//
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     myColor = Theme.of(context).primaryColor;
//     mediaSize = MediaQuery.of(context).size;
//     return Container(
//       color: Color.fromARGB(255, 149, 137, 74),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Stack(
//           children: [
//             Positioned(top: 80, child: _buildTop()),
//             Positioned(bottom: 0, child: _buildBottom()),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTop() {
//     return SizedBox(
//       width: mediaSize.width,
//       child: const Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             'WhatsOn@UP',
//             style: TextStyle(
//               fontSize: 40,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 2,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBottom() {
//     return SizedBox(
//       width: mediaSize.width,
//       child: Card(
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30),
//             topRight: Radius.circular(30),
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(32.0),
//           child: _buildForm(),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildForm() {
//     final theme = Theme.of(context);
//     final signupTextColour = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
//
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Login to Your Account',
//             style: TextStyle(
//               fontSize: 24,
//
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 50),
//           _buildInputField(
//             emailController,
//             label: "Email",
//             icon: Icons.email,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter your email';
//               }
//               final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
//               if (!regex.hasMatch(value)) {
//                 return 'Enter a valid email address';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 40),
//           _buildInputField(
//             passwordController,
//             label: "Password",
//             icon: Icons.lock,
//             isPassword: true,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please enter your password';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 30),
//           _buildRememberForgot(),
//           const SizedBox(height: 10),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: _login,
//               style: ElevatedButton.styleFrom(
//                 // backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//                 foregroundColor: Colors.black, backgroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                   side: BorderSide(color: Colors.grey, width: 1),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//               child: Text(
//                 'Login',
//                 // style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
//
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _buildGreyText("Don't have an account yet?"),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const SigninPage()),
//                   );
//                 },
//                 child: Text(
//                   'Sign up',
//                   // style: TextStyle(color: Colors.black),
//                   style: TextStyle(color: signupTextColour),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 110),
//           Center(
//             child: _buildGreyText("Or sign in with"),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                   icon: const Image(
//                     width: 32,
//                     height: 32,
//                     image: Svg('assets/images/google-icon.svg'),
//                   ),
//                 onPressed:() {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const GoogleSignInPage ()),
//                   );
//                 },
//
//               ),
//
//             ],
//           ),
//           const SizedBox(height: 10),
//           Center(
//             child: Center(
//               child: TextButton(
//                 onPressed: () {},
//                 child: _buildGreyText("Sign in as a guest user"),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildGreyText(String text) {
//     return Text(
//       text,
//       style: const TextStyle(color: Colors.grey),
//     );
//   }
//
//   Widget _buildInputField(
//     TextEditingController controller, {
//     required String label,
//     required IconData icon,
//     bool isPassword = false,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.grey),
//         prefixIcon: Icon(icon, color: Colors.grey),
//         suffixIcon: isPassword
//             ? IconButton(
//           icon: Icon(
//             _isObscured ? Icons.visibility : Icons.visibility_off,
//             color: Colors.grey,
//           ),
//           onPressed: () {
//             setState(() {
//               _isObscured = !_isObscured;
//             });
//           },
//         )
//             : null,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Colors.grey),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Colors.grey),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: Colors.black),
//         ),
//       ),
//       obscureText: isPassword ? _isObscured : false,
//       validator: validator,
//     );
//   }
//
//   Widget _buildRememberForgot() {
//     return Row(
//       children: [
//         Row(
//           children: [
//             Checkbox(
//                 value: rememberUser,
//                 onChanged: (value) {
//                   setState(() {
//                     rememberUser = value!;
//                   });
//                 }),
//             _buildGreyText('Remember me'),
//           ],
//         ),
//         TextButton(
//             onPressed: () {}, child: _buildGreyText('I forgot my password'))
//       ],
//     );
//   }
//
//
//   Future<void> _login() async {
//     if (_formKey.currentState!.validate()) {
//       String email = emailController.text;
//       String password = passwordController.text;
//       Api api = Api();
//       api.loginUser(email, password).then((response) {
//         if (response['error'] != null) {
//
//           print('An error occurred: ${response['error']}');
//         } else {
//           String fullName = response['data']['user']['fullName']?? 'Unknown';
//           String userEmail = response['data']['user']['email'] ?? 'Unknown';
//           String UserId=response['data']['user']['id']?? 'Unknown';
//           String role=response['data']['user']['role']?? 'Unknown';
//           String  profileImage=response['data']['user']['profileImage']?? 'Unknown';
//           Uint8List profileImageBytes = Uint8List(0);
//
//           bool isBase64(String input) {
//             final RegExp base64 = RegExp(
//               r'^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$',
//             );
//             return base64.hasMatch(input);
//           }
//
//           if (isBase64(profileImage)) {
//
//             try {
//               profileImageBytes = base64Decode(profileImage);
//             } catch (e) {
//               print('Error decoding Base64: $e');
//             }
//           } else {
//             print('Invalid Base64 string: $profileImage');
//           }
//
//
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => HomePage(
//               userName:  fullName,
//               userEmail: userEmail,
//               userId:UserId,
//               role:role,
//               profileImage: profileImageBytes,
//             )),
//           );
//           print('Login successful');
//         }
//       });
//
//
//     }
//   }

// Future<void> _login() async {
//   if (_formKey.currentState!.validate()) {
//     String email = emailController.text;
//     String password = passwordController.text;
//     Api api = Api();
//     api.loginUser(email, password).then((response) {
//       if (response['error'] != null) {
//
//         print('An error occurred: ${response['error']}');
//       } else {
//         String fullName = response['data']['user']['fullName']?? 'Unknown';
//         String userEmail = response['data']['user']['email'] ?? 'Unknown';
//         String UserId=response['data']['user']['id']?? 'Unknown';
//         String role=response['data']['user']['role']?? 'Unknown';
//         String  profileImage=response['data']['user']['profileImage']?? 'Unknown';
//         Uint8List profileImageBytes = Uint8List(0);
//
//         bool isBase64(String input) {
//           final RegExp base64 = RegExp(
//             r'^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$',
//           );
//           return base64.hasMatch(input);
//         }
//
//         if (isBase64(profileImage)) {
//
//           try {
//             profileImageBytes = base64Decode(profileImage);
//           } catch (e) {
//             print('Error decoding Base64: $e');
//           }
//         } else {
//           print('Invalid Base64 string: $profileImage');
//         }
//
//
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => HomePage(
//             userName:  fullName,
//             userEmail: userEmail,
//             userId:UserId,
//             role:role,
//             profileImage: profileImageBytes,
//           )),
//         );
//         print('Login successful');
//       }
//     });
//
//
//   }
// }
// void loginGoogle{
//   final user = supabase.auth.currentUser;
//   final profileImageUrl = user?.userMetadata?['avatar_url'];
//   final fullName = user?.userMetadata?['full_name'];
//   final email=user?.userMetadata?['email'];
//   final role=user?.userMetadata?['role'];
//   Uint8List profileImageBytes = Uint8List(0);
//
//   if (profileImageUrl != null) {
//   profileImageBytes = decodeProfileImage(profileImageUrl);
//   }
//
//   Api api = Api();
// }

// Uint8List decodeProfileImage(String profileImage) {
//   Uint8List profileImageBytes = Uint8List(0);
//
//   bool isBase64(String input) {
//     final RegExp base64 = RegExp(
//       r'^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$',
//     );
//     return base64.hasMatch(input);
//   }
//
//   if (isBase64(profileImage)) {
//     try {
//       profileImageBytes = base64Decode(profileImage);
//     } catch (e) {
//       print('Error decoding Base64: $e');
//     }
//   } else {
//     print('Invalid Base64 string: $profileImage');
//   }
//
//   return profileImageBytes;
// }

//}
