
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class TabGeneral extends StatelessWidget {
  const TabGeneral({super.key});




  @override
  Widget build(BuildContext context) {


    return DefaultTabController(
      length: 3,

      child: Scaffold(

        appBar: AppBar(

          title: const Text('Manage General Applications'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Pending'),
              Tab(text: 'Verified'),
            ],
            labelColor:Color.fromARGB(255, 149, 137, 74),
            unselectedLabelColor: Colors.black,
            indicatorColor: Color.fromARGB(255, 149, 137, 74),


          ),

        ),
        body: const TabBarView(
          children: [
            UserList(statusFilter: null), // All users
            UserList(statusFilter: 'PENDING',), // Pending users
            UserList(statusFilter: 'VERIFIED'), // Verified users
          ],
        ),
      ),
    );
  }






}

class UserList extends StatelessWidget {
  final String? statusFilter;


  const UserList({super.key, this.statusFilter});

  @override
  Widget build(BuildContext context) {
    userProvider userP = Provider.of<userProvider>(context, listen:false);
    // final Future<GeneralApplications>? generalApplicationsFuture = userP.generalApplications;
    // print(''generalApplicationsFuture);
    return FutureBuilder<GeneralApplications>(

      future: userP.generalApplications,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('An error occurred: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData) {
          print('future: ${userP.generalApplications}');
          return Center(
            child: Text('No users found'),
          );
        } else {
          var users = snapshot.data!.data;

          var filteredUsers = statusFilter == null
              ? users
              : users.where((n) => n.status.name == statusFilter).toList();

          return ListView.separated(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              var user = filteredUsers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.user.profileImage!.isNotEmpty
                      ? NetworkImage( user.user.profileImage!)
                      : const AssetImage('assets/images/user.png') as ImageProvider,
                  radius: 20,
                ),
                title: Center(
                  child: Text(user.user.fullName),
                ),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => appllicant(user: user),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          );
        }
      },
    );
  }


}



class Usergeneral {
  late final String fullName;
  late final String userStatus;
  late final String? profileImage;

  Usergeneral(this.fullName, this.userStatus, this.profileImage);
}

Widget statusButton(String status) {
  // Define your status button widget here.
  return Text(status);
}

class appllicant extends StatelessWidget {
  final Application user;

  const appllicant({super.key, required this.user});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(user.user.fullName)),
      body: Center(child: Text('Event details for ${user.user.fullName}')),
    );
  }
}
