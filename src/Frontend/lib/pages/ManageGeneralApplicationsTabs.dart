import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../screens/ApplicantDetailsPage.dart';
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
            labelColor: Color.fromARGB(255, 149, 137, 74),
            unselectedLabelColor: Colors.black,
            indicatorColor: Color.fromARGB(255, 149, 137, 74),
          ),
        ),
        body: const TabBarView(
          children: [
            UserList(statusFilter: null),
            UserList(statusFilter: 'PENDING'),
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
    userProvider userP = Provider.of<userProvider>(context, listen: false);

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
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Material(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.user.profileImage.isNotEmpty &&
                              user.user.profileImage != null
                          ? NetworkImage(user.user.profileImage)
                          : const AssetImage('assets/images/user.png')
                              as ImageProvider,
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
                          builder: (context) => Applicant(user: user),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(color: Colors.transparent),
          );
        }
      },
    );
  }
}

class Applicant extends StatefulWidget {
  final Application user;

  const Applicant({super.key, required this.user});

  @override
  _ApplicantState createState() => _ApplicantState();
}

class _ApplicantState extends State<Applicant> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user.user.fullName ?? "Unknown")),
      body: _isLoading
          ? Center(
              child: SpinKitPianoWave(
                color: Color.fromARGB(255, 149, 137, 74),
                size: 50.0,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: CircleAvatar(
                    radius: 60.0,
                    backgroundImage:
                        NetworkImage(widget.user.user.profileImage),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  widget.user.user.fullName ?? "Unknown",
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
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ApplicantDetailsPage(user: widget.user),
                          ),
                        );
                      },
                      child: Text(
                        'Click here to view the application details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 10.0),
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Text(
                //     'Duration: ${widget.user.expiryDateTime}',
                //     textAlign: TextAlign.center,
                //     style: TextStyle(fontSize: 18.0),
                //   ),
                // ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Status: ${widget.user.status.name}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                SizedBox(height: 10.0),
                 if (widget.user.status.name == 'PENDING')
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'This person is yet to be verified.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.red),
                    ),

                  )
                else if (widget.user.status.name == 'ACKNOWLEDGED') ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _updateApplication(context, 'Demote');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0), // Adjust padding if needed
                          ),
                          child: Text('Demote'),
                        ),
                      ],
                    ),
                  ),
                ] else if (widget.user.status.name == 'VERIFIED') ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _updateApplication(context, 'Reject');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0), // Adjust padding if needed
                          ),
                          child: Text('Reject'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _updateApplication(context, 'Accept');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0), // Adjust padding if needed
                          ),
                          child: Text('Accept'),
                        ),
                      ],
                    ),
                  ),
                ],
                if (widget.user.proofUrl != null && widget.user.status.name == 'PENDING') ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _updateApplication(context, 'Reject');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
                          ),
                          child: Text('Reject'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _updateApplication(context, 'Accept');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
                          ),
                          child: Text('Accept'),
                        ),
                      ],
                    ),
                  ),
                ],
                if (widget.user.proofUrl != null && widget.user.status.name =='VERIFIED') ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _updateApplication(context, 'Reject');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
                          ),
                          child: Text('Reject'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _updateApplication(context, 'Accept');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0),
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

  Future<void> _updateApplication(BuildContext context, String action) async {
    setState(() {
      _isLoading = true;
    });

    Api api = Api();
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    final userId = userP.userId;
    final applicationId = widget.user.applicationId;
    final response = action == 'Accept'
        ? await api.AcceptApplication(
            userId: userId, applicationId: applicationId)
        : action == 'Reject'
            ? await api.DeclineApplication(
                userId: userId, applicationId: applicationId)
            : await api.DemoteApplicant(
                userIdAdmin: userId,
                userId: widget.user.user.userId,
                applicationId: applicationId);

    setState(() {
      _isLoading = false;
    });

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$action successful')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to $action')),
      );
    }

    userP.Generalusers(userId);
    Navigator.of(context).pushReplacementNamed('/home');
  }
}
