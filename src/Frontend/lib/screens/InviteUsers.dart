import 'package:firstapp/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/services/api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class InviteUsers extends StatefulWidget {
  final String eventId;

  const InviteUsers({super.key, required this.eventId});

  @override
  _InviteUsersWidgetState createState() => _InviteUsersWidgetState();
}

class _InviteUsersWidgetState extends State<InviteUsers> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _foundUsers = [];
  final List<UserModel> _invitedUsers = [];
  bool _isSearching = false;
  bool _isSendingInvites = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _searchUsers(_searchController.text);
    });
  }

  Future<void> _searchUsers(String query) async {
    setState(() {
      _isSearching = true;
    });
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    String userId = userP.userId;
    List<UserModel> users = await Api.getAllUsers(userP.JWT);

    setState(() {
      _foundUsers = users
          .where((user) =>  user.userId != userId && user.fullName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _isSearching = false;
    });
  }

  Future<void> _sendInvites() async {
    try {
      setState(() {
        _isSendingInvites = true;
      });

      userProvider userP = Provider.of<userProvider>(context, listen: false);
    String userId = userP.userId;

    for (var user in _invitedUsers) {
      await Api.inviteUser(widget.eventId, userP.JWT, user.userId); // Adjust this function based on your API implementation
    }

    setState(() {
      _invitedUsers.clear();
      _isSendingInvites = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invitations sent successfully!')),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) =>const HomePage()),
    );
  }
    catch (e) {
      setState(() {
        _isSendingInvites = false;
      });
      _showErrorDialog('Error', 'Failed to send invites. Please try again.');
    }
  }

  void _addUserToInvite(UserModel user) {
    setState(() {
      if (!_invitedUsers.contains(user)) {
        _invitedUsers.add(user);
        _foundUsers.remove(user); // Optionally remove from found users
      }
    });
  }

  void _removeUserFromInvite(UserModel user) {
    setState(() {
      _invitedUsers.remove(user);
      if (!_foundUsers.contains(user)) {
        _foundUsers.add(user); // Optionally add back to found users
      }
    });
  }
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Users'),
      ),
      body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search users to invite',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _isSendingInvites
                ? const SpinKitPianoWave(
              color: Color.fromARGB(255, 149, 137, 74),
              size: 50.0,
            )
                : IconButton(
              icon: const Icon(Icons.send),
              onPressed: _invitedUsers.isEmpty ? null : _sendInvites,
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (_isSearching)
          const Center(child: SpinKitPianoWave(color: Color.fromARGB(255, 149, 137, 74), size: 50.0))
        else if (_foundUsers.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: _foundUsers.length,
              itemBuilder: (context, index) {
                final user = _foundUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.profileImageUrl), // Assuming UserModel has a profileImageUrl field
                  ),
                  title: Text(user.fullName),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _addUserToInvite(user),
                  ),
                );
              },
            ),
          ),
        if (_invitedUsers.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Invited Users: (${_invitedUsers.length}):'),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true, // Important to avoid overflow in Column
                itemCount: _invitedUsers.length,
                itemBuilder: (context, index) {
                  final user = _invitedUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.profileImageUrl),
                    ),
                    title: Text(user.fullName),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete , color: Colors.red),
                      onPressed: () => _removeUserFromInvite(user),
                    ),
                  );
                },
              ),
            ],
          ),

      ],
    ),
    );

  }
}

class UserModel {
  final String userId;
  final String fullName;
  final String profileImageUrl;
  final Map<String, dynamic> role;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.profileImageUrl,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      fullName: json['fullName'],
      profileImageUrl: json['profileImage'],
      role: json['role'],
    );
  }
}
