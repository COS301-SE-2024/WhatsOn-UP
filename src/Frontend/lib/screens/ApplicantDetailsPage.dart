import 'package:flutter/material.dart';
import '../services/api.dart';
import '../providers/user_provider.dart';
import '../utils.dart';

class ApplicantDetailsPage extends StatelessWidget {
  final Application user;

  const ApplicantDetailsPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    String formattedDateSentAt = formatDateTime( user.expiryDateTime);
    return Scaffold(
      appBar: AppBar(
        title: Text('Applicant Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reason:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.0),
            Container(
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
              child: SingleChildScrollView(
                child: Text(
                  user.reason ?? 'No reason provided.',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Duration:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.0),
            Text(
              formattedDateSentAt ?? 'No duration provided.',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _showDocument(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20.0), // Adjust padding if needed
              ),
              child: Text('View Document'),
            ),
            SizedBox(height: 16.0),
            _buildAcceptedRejectedByInfo(user.acceptedRejectedBy, user.status),

          ],
        ),
      ),
    );
  }

  Widget _buildAcceptedRejectedByInfo(AcceptedRejectedBy? acceptedRejectedBy,
      Status status) {
    if (acceptedRejectedBy == null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Accepted/Rejected by: No data',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
        ),
      );
    }

    // Check the status and display the appropriate information
    if (status.name == 'ACCEPTED' || status.name == 'REJECTED') {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Display CircleAvatar only if status is ACCEPTED or REJECTED
            CircleAvatar(
              backgroundImage: acceptedRejectedBy.profileImage != null &&
                  acceptedRejectedBy.profileImage.isNotEmpty
                  ? NetworkImage(acceptedRejectedBy.profileImage)
                  : const AssetImage('assets/images/user.png') as ImageProvider,

              radius: 20,
            ),
            SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${status.name == 'ACCEPTED'
                        ? 'Accepted by:'
                        : 'Rejected by:'} ${acceptedRejectedBy.fullName}',
                    style: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Role: ${acceptedRejectedBy.role.name}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "The Admin hasn't accepted or rejected this application yet.",
          style: TextStyle(fontSize: 16.0),
        ),
      );
    }
  }

  void _showDocument(BuildContext context) {
    final Widget documentWidget = _getDocument(user.proofUrl);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Document'),
        content: documentWidget,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),

            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _getDocument(String? documentUrl) {
    if (documentUrl != null && documentUrl.isNotEmpty) {
      return Image.network(documentUrl);
    }
    return Text('No document provided');
  }
}