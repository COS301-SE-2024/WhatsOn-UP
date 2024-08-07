import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  SocketService(String url, String userId) {
    // Create a custom header with the authorization token
    final headers = {
      'Authorization': 'Bearer $userId',
    };

    // Configure the socket with the custom header
    socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': headers,
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
  }

  void sendMessage(String event, dynamic message) {
    socket.emit(event, message);
  }

  void dispose() {
    socket.dispose();
  }
}