import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

// class ManageEvents extends StatelessWidget {
//   const ManageEvents({super.key});
//   bool _isLoading = false;
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Stack(
// //         children: [
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               const SizedBox(height: 40),
// //               const Padding(
// //                 padding: EdgeInsets.fromLTRB(48.0, 16.0, 16.0, 16.0),
// //                 child: Text(
// //                   'Manage Events',
// //                   style: TextStyle(
// //                     fontSize: 32,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ),
// //               const SizedBox(height: 350),
// //               const Center(
// //                 child: Text('Manage Events Page - Coming soon'),
// //               ),
// //             ],
// //           ),
// //           Positioned(
// //             top: 60.0,
// //             left: 10.0,
// //             child: IconButton(
// //               onPressed: () {
// //                 Navigator.pop(context);
// //               },
// //               icon: const Icon(LineAwesomeIcons.angle_left_solid),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     final theme = Theme.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(LineAwesomeIcons.angle_left_solid),
//         ),
//         title: Text('Edit Profile'),
//       ),
//       body:  _isLoading
//           ? const Center(child:SpinKitPianoWave(
//         color:  Color.fromARGB(255, 149, 137, 74),
//         size: 50.0,
//       ))
//           :Stack(
//         children: [
//           Positioned(
//             top: 50,
//             left: 50,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: Container(
//                 height: 200,
//                 width: 200,
//                 color: Colors.blue, // Example color
//                 child: Center(
//                   child: Text(
//                     'Category 1',
//
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 150,
//             left: 150,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: Container(
//                 height: 200,
//                 width: 200,
//                 color: Colors.green, // Example color
//                 child: Center(
//                   child: Text(
//                     'Category 2',
//
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//  }
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:line_awesome_flutter/line_awesome_flutter.dart';
//
// class ManageEvents extends StatelessWidget {
//    ManageEvents({Key? key}) : super(key: key);
//
//   bool _isLoading = false; // Assuming this is declared elsewhere in your class
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(LineAwesomeIcons.angle_left_solid),
//         ),
//         title: Text('Edit Profile'),
//       ),
//       body: _isLoading
//           ? Center(
//         child: SpinKitPianoWave(
//           color: const Color.fromARGB(255, 149, 137, 74),
//           size: 50.0,
//         ),
//       )
//           :
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:line_awesome_flutter/line_awesome_flutter.dart';
//
// class ManageEvents extends StatelessWidget {
//   ManageEvents({Key? key}) : super(key: key);
//
//   bool _isLoading = false; // Assuming this is declared elsewhere in your class
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(LineAwesomeIcons.angle_left_solid),
//         ),
//         title: Text('Manage Events'),
//       ),
//       body: _isLoading
//           ? Center(
//         child: SpinKitPianoWave(
//           color: const Color.fromARGB(255, 149, 137, 74),
//           size: 50.0,
//         ),
//       )
//           : Column(
//         children: [
//           const SizedBox(height: 30),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: Container(
//               height: 50,
//               width: 400,
//               color: Color.fromARGB(255, 149, 137, 74), // Example color
//               child: Center(
//                 child: Text(
//                   'Category 1',
//
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 30),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: Container(
//               height: 50,
//               width: 400,
//               color: Color.fromARGB(255, 149, 137, 74), // Example color
//               child: Center(
//                 child: Text(
//                   'Category 2',
//
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../widgets/eventManagement_category.dart';

class ManageEvents extends StatelessWidget {
  ManageEvents({Key? key}) : super(key: key);

  bool _isLoading = false; // Assuming this is declared elsewhere in your class

  @override
  Widget build(BuildContext context) {
    userProvider userP = Provider.of<userProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: Text('Manage Events'),
      ),
      body: _isLoading
          ? Center(
        child: SpinKitPianoWave(
          color: const Color.fromARGB(255, 149, 137, 74),
          size: 50.0,
        ),
      )
          : Column(
        children: [
          _buildProfileOption(
            text: userP.role == 'ADMIN' ? 'All Events' : 'My Events',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventmanagementCategory()),
              );
            },
          ),
          _buildDivider(),
          _buildProfileOption(
            text: 'Past Events',
            onTap: () {

            },
          ),

        ],
      ),
    );
  }
}
Widget _buildProfileOption({

  required String text,
  Widget? trailing,
  required VoidCallback onTap,
}) {
  return ListTile(

    title: Text(text),
    trailing: trailing != null
        ? SizedBox(
      width: 100,
      child: trailing,
    )
        : const Icon(Icons.arrow_forward),
    onTap: onTap,
  );
}

Widget _buildDivider() {
  return const Divider(
    height: 1,
    thickness: 1,
    indent: 16,
    endIndent: 16,
  );
}