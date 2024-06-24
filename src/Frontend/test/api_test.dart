import 'package:firstapp/services/api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Api', () {
    final api = Api();

    test('loginUser throws an exception on failed login', () async {
      final String email = 'wrong@example.com';
      final String password = 'wrongpassword';

      try {
        await api.loginUser(email, password);
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e.toString(), contains('Exception:'));
      }
    });

    test('loginUser returns user details on successful login', () async {
      final String email = 'host@gmail.com';
      final String password = 'password';

      try {
        final response = await api.loginUser(email, password);
        expect(response['status'], 'success');
      } catch (e) {
        fail('loginUser failed: $e');
      }
    });


    test('getAllEvents returns a list of events', () async {
      try {
        final response = await api.getAllEvents();
        expect(response, isA<List<dynamic>>());
      } catch (e) {
        fail('getAllEvents failed: $e');
      }
    });


    test('getRSVPEvents returns a list of rsvpd events', () async {
      try {
        final response = await api.getRSVPEvents();
        expect(response, isA<List<dynamic>>());
      } catch (e) {
        fail('getRSVPEvents failed: $e');
      }
    });


    test('postChangeUser updates user details', () async {
      try {
        final response = await api.postChangeUser(
          'host',
          'host@gmail.com',
          '',
        );
        expect(response['status'], 'success');
      } catch (e) {
        fail('postChangeUser failed: $e');
      }
    });

    test('postChangeUser throws an exception on error', () async {
      String temp = api.jwtKey;
      api.jwtKey = 'invalid_jwt_token';

      try {
        await api.postChangeUser(
          'New Name',
          'newemail@example.com',
          'profileImageURL',
        );
        fail("contains 'Exception:'");
      } catch (e) {
        expect(e.toString(), contains('Exception:'));
      }
      finally {
        api.jwtKey = temp;
      }
    });

    test('updatePassword changes the user password', () async {
      try {
        final response = await api.updatePassword('password');
      } catch (e) {
        fail('updatePassword failed: $e');
      }
    });

    test('updatePassword throws an exception on error', () async {
      String temp = api.jwtKey;
      api.jwtKey = 'invalid_jwt_token';

      try {
        await api.updatePassword('newpassword123');
        fail("'contains 'Exception:'");
      } catch (e) {
        expect(e.toString(), contains('Exception:'));
      }
      finally {
        api.jwtKey = temp;
      }
    });

    test('createEvent creates a new event', () async {
      try {
        final response = await api.createEvent(
          title: 'New Event',
          description: 'Event Description',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(hours: 2)),
          location: 'Event Location',
          maxParticipants: 100,
          metadata: 'metadata',
          isPrivate: false,
          media: ['media1', 'media2'],
        );
        print(response);
      } catch (e) {
        fail('createEvent failed: $e');
      }
    });

    test('createEvent throws an exception on error', () async {
      String temp = api.jwtKey;
      api.jwtKey = 'invalid_jwt_token';

      try {
        await api.createEvent(
          title: 'New Event',
          description: 'Event Description',
          startDate: DateTime.now(),
          endDate: DateTime.now().add(Duration(hours: 2)),
          location: 'Event Location',
          maxParticipants: 100,
          metadata: 'metadata',
          isPrivate: false,
          media: ['media1', 'media2'],
        );
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e.toString(), contains('Exception:'));
      }
      finally {
        api.jwtKey = temp;
        print('api.jwtKey: ${api.jwtKey}');
      }
    });
  });

}
