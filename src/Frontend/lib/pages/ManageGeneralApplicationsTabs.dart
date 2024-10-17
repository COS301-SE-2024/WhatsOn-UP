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
    userProvider userP = Provider.of<userProvider>(context, listen: true);
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
    body: TabBarView(
      children: [
        RefreshIndicator(
          onRefresh: userP.refreshApplications,
          child: const UserList(statusFilter: null),
        ),
        RefreshIndicator(
          onRefresh: userP.refreshApplications,
          child: const UserList(statusFilter: 'PENDING'),
        ),
        RefreshIndicator(
          onRefresh: userP.refreshApplications,
          child: const UserList(statusFilter: 'VERIFIED'),
        ),
        RefreshIndicator(
          onRefresh: userP.refreshApplications,
          child: const UserList(statusFilter: 'ACKNOWLEDGED'),
        ),
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
// Function to return color based on status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'VERIFIED':
        return Color.fromARGB(255, 0, 128, 132);
      case 'ACCEPTED':
        return Color.fromARGB(255, 0, 150, 243);
      case 'REJECTED':
        return Colors.red;
      case 'DISPUTED':
        return Colors.purple;
      case 'ACKNOWLEDGED':
        return Color.fromARGB(255, 135, 67, 20);
      default:
        return Colors.grey; // Default color
    }
  }

// Function to return icon based on status
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'PENDING':
        return Icons.hourglass_empty;
      case 'VERIFIED':
        return Icons.verified;
        return Icons.thumb_up;
      case 'REJECTED':
        return Icons.cancel;
      case 'DISPUTED':
        return Icons.warning;
      case 'ACKNOWLEDGED':
        return Icons.check_circle_outline;
      default:
        return Icons.info;
    }
  }

  void _showStatusInfo(String status) {
    String infoMessage;
    switch (status) {
      case 'PENDING':
        infoMessage = 'A verification link has been sent to the user\'s email to verify their identity, or the user has uploaded their hosting proof and is waiting for approval.';
      case 'VERIFIED':
        infoMessage = 'The user has verified through the verification link sent to their email.';
        break;
      case 'REJECTED':
        infoMessage = 'The application was rejected by an admin, or the user\'s privileges have been revoked.';
        break;
      case 'DISPUTED':
        infoMessage = 'The application is under dispute.'; //not implemented yet
        break;
      case 'ACKNOWLEDGED':
        infoMessage = 'The application has been approved by an admin and the user has acknowledged that they have been accepted.'; 
        break;
      default:
        infoMessage = 'Error getting status information.';
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Status Information'),
          content: Text(infoMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

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
          : SingleChildScrollView( 
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundImage:
                            NetworkImage(widget.user.user.profileImage),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Center(
                    child: Text(
                      widget.user.user.fullName ?? "Unknown",
                      style:
                          TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
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
                        child: const Text(
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
                  SizedBox(height: 20.0),
                  if (widget.user.alert)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning,
                              color: Colors.white,
                              size: 24.0,
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                'This person has a history of creating events that receive consistently low ratings. Please review the application carefully before accepting.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(widget.user.status.name), // Background color based on status
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(widget.user.status.name), // Icon based on status
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Status: ${widget.user.status.name}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            Icons.info_outline,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _showStatusInfo(widget.user.status.name);
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.0),
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
                                  horizontal: 20.0),
                            ),
                            child: Text('Demote'),
                          ),
                        ],
                      ),
                    ),
                  ] else if (widget.user.status.name == 'VERIFIED' ||
                      (widget.user.proofUrl != null &&
                          widget.user.status.name == 'PENDING') ||
                      (widget.user.proofUrl != null &&
                          widget.user.status.name == 'VERIFIED')) ...[
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
            JWT: userP.JWT, applicationId: applicationId)
        : action == 'Reject'
            ? await api.DeclineApplication(
                JWT: userP.JWT, applicationId: applicationId)
            : await api.DemoteApplicant(
                JWT: userP.JWT,
                userId: widget.user.user.userId,
                applicationId: applicationId);

    setState(() {
      _isLoading = false;
    });

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$action successful'),
          backgroundColor: Colors.green,),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to $action'),
          backgroundColor: Colors.red,),
      );
    }

    userP.Generalusers(userP.JWT);
    Navigator.of(context).pushReplacementNamed('/home');
  }
}
