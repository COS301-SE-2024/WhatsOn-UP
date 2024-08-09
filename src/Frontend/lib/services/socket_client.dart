import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  SocketService(String url, String userId) {

    final headers = {
      'Authorization': 'Bearer $userId',
    };


    socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': <String, String>{
        'Authorization': 'Bearer $userId',
      },
    });

    // Add event listeners
    socket.on('connect', (_) {
      print('Connected: ${socket.id}');
    });

    socket.on('disconnect', (_) {
      print('Disconnected');
    });

    socket.on('event', (data) {
      print('Event received: $data');
    });
    socket.on('error', (error) {
      print('Error: $error');
    });
  }

  void sendMessage(String event, dynamic message) {
    socket.emit(event, message);
  }

  void dispose() {
    socket.dispose();
  }
}
//
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// class SocketService {
//   late IO.Socket socket;
//
//   // Constructor to set up the socket
//   SocketService(String url, String userId) {
//     final headers = {
//       'Authorization': 'Bearer $userId',
//     };
//
//     // Setting up the socket connection
//     socket = IO.io(url, <String, dynamic>{
//       'transports': ['websocket'],
//       'extraHeaders': headers,
//     });
//
//     // Attach common event listeners
//     socket.on('connect', (_) {
//       print('Connected: ${socket.id}');
//     });
//
//     socket.on('disconnect', (_) {
//       print('Disconnected');
//     });
//
//
//     _setupListeners();
//   }
//
//   // Method to set up custom listeners
//   void _setupListeners() {
//     // socket.on('messageReceived', (data) {
//     //   print('Message received: $data');
//     // });
//
//     socket.on('userJoined', (data) {
//       print('User joined: $data');
//     });
//
//     // Listen for notification events
//     socket.on('notification', (data) {
//       print('Notification received: $data');
//       _handleNotification(data); // Handle the notification
//     });
//
//     socket.on('error', (error) {
//       print('Error: $error');
//     });
//   }
//
//   // Method to handle notification events
//   void _handleNotification(dynamic data) {
//     print('Processing notification: $data');
//     // Add your notification handling logic here
//   }
//
//   // Method to send messages to the server
//   void sendMessage(String event, dynamic message) {
//     socket.emit(event, message);
//   }
//
//   // Dispose method to clean up the socket
//
//   void dispose() {
//     try {
//       if (socket != null) {
//         socket.dispose();
//       }
//     } catch (e) {
//       print('Error disposing socket: $e');
//     }
//   }
//
//
//
// }