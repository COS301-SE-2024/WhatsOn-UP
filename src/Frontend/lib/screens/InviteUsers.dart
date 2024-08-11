import 'package:firstapp/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/services/api.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class InviteUsers extends StatefulWidget {
  final String eventId;

  const InviteUsers({Key? key, required this.eventId}) : super(key: key);

  @override
  _InviteUsersWidgetState createState() => _InviteUsersWidgetState();
}

class _InviteUsersWidgetState extends State<InviteUsers> {
  TextEditingController _searchController = TextEditingController();
  List<UserModel> _foundUsers = [];
  List<UserModel> _invitedUsers = [];
  bool _isSearching = false;

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
    List<UserModel> users = await Api.getAllUsers(userId);

    setState(() {
      _foundUsers = users
          .where((user) => user.fullName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _isSearching = false;
    });
  }

  Future<void> _sendInvites() async {
    userProvider userP = Provider.of<userProvider>(context, listen: false);
    String userId = userP.userId;

    for (var user in _invitedUsers) {
      await Api.inviteUser(widget.eventId, userId, user.userId); // Adjust this function based on your API implementation
    }

    setState(() {
      _invitedUsers.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invitations sent successfully!')),
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) =>HomePage()),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Users'),
      ),
      body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search users to invite',
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: _sendInvites,
            ),
          ),
        ),
        SizedBox(height: 10),
        if (_isSearching)
          Center(child: CircularProgressIndicator())
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
                  title: Text(user.fullName), // Assuming UserModel has a fullName field
                  trailing: IconButton(
                    icon: Icon(Icons.add),
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
              Text('Invited Users:'),
              SizedBox(height: 10),
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
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeUserFromInvite(user),
                    ),
                  );
                },
              ),
            ],
          ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _invitedUsers.isEmpty ? null : _sendInvites,
          child: Text('Send Invites'),
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
