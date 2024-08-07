
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../services/api.dart';

class TabGeneral extends StatelessWidget {
  const TabGeneral({super.key});




  @override
  Widget build(BuildContext context) {


    return DefaultTabController(
      length: 4,

      child: Scaffold(

        appBar: AppBar(

          title: const Text('Manage General Applications'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Pending'),
              Tab(text: 'Verified'),
              Tab(text: 'Promoted'),
            ],
            labelColor:Color.fromARGB(255, 149, 137, 74),
            unselectedLabelColor: Colors.black,
            indicatorColor: Color.fromARGB(255, 149, 137, 74),


          ),

        ),
        body: const TabBarView(
          children: [
            UserList(statusFilter: null),
            UserList(statusFilter: 'PENDING',),
            UserList(statusFilter: 'VERIFIED'),
            UserList(statusFilter: 'ACKNOWLEDGED'),
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
              : users.where((n) => n.status.name == statusFilter ).toList();
          return ListView.separated(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              var user = filteredUsers[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.user.profileImage!.isNotEmpty
                        ? NetworkImage(user.user.profileImage!)
                        : const AssetImage('assets/images/user.png') as ImageProvider,
                    radius: 20,
                  ),
                  title: Center(
                    child: Text(user.user.fullName ?? "Unknown"),
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => appllicant(user: user),
                      ),
                    );
                  },
                ),
              );


            },
            separatorBuilder: (BuildContext context, int index) => const Divider(  color: Colors.transparent),
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

  return Text(status);
}

class appllicant extends StatelessWidget {
  final Application user;

  const appllicant({super.key, required this.user});


  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;
    return Scaffold(
      appBar: AppBar(title: Text(user.user.fullName ?? "Unknown",)),
      body: _isLoading
          ?  Center(child:SpinKitPianoWave(
        color:  Color.fromARGB(255, 149, 137, 74),
        size: 50.0,
      ))
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: CircleAvatar(
              radius: 60.0, // Adjust size as needed
              backgroundImage: NetworkImage(user.user.profileImage),
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            user.user.fullName ?? "Unknown",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Text(
                'Reason: ${user.reason}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Duration: ${user.expiryDateTime}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Status: ${user.status.name}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Spacer(),

          if (user.status.name == 'PENDING')
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'This person is yet to be verified.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.red),
              ),
            ),
          if (user.status.name == 'ACCEPTED') ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      userProvider userP = Provider.of<userProvider>(context, listen: false);
                      _isLoading = true;
                      DeclineApplication(context, userP.userId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      textStyle: TextStyle(color: Colors.white),
                    ),
                    child: Text('Demote'),
                  ),
                ],
              ),
            ),
          ]
          else ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      userProvider userP = Provider.of<userProvider>(context, listen: false);
                      _isLoading = true;
                      DeclineApplication(context, userP.userId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      textStyle: TextStyle(color: Colors.white),
                    ),
                    child: Text('Reject'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      userProvider userP = Provider.of<userProvider>(context, listen: false);
                      _isLoading = true;
                      AcceptApplication(context, userP.userId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Background color
                      textStyle: TextStyle(color: Colors.white),
                    ),
                    child: Text('Accept'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );



  }
  Future<void> DeclineApplication(BuildContext context, String userId) async {
    Api api = Api();
userProvider userP = Provider.of<userProvider>(context, listen: false);
   final response= await api.DeclineApplication(userId: userId, applicationId: user.applicationId);
    print(response);
    userP.Generalusers(userP.userId);

  }

  Future<void> AcceptApplication(BuildContext context, String userId) async {
    Api api = Api();
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    final response=await api.AcceptApplication(userId: userId, applicationId: user.applicationId);
    print(response);
    userP.Generalusers(userP.userId);
  }
  Future<void> DemoteApplicant(BuildContext context, String userIdAdmin) async {



    Api api = Api();
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    final response=await api.DemoteApplicant(userIdAdmin: userIdAdmin,userId: user.user.userId, applicationId: user.applicationId);
    print(response);
    userP.Generalusers(userP.userId);
  }
}
