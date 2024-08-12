import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:firstapp/providers/user_provider.dart';


import 'package:mockito/mockito.dart';
import 'api_test.mocks.dart';



void main() {
  late userProvider provider;
  late MockApi mockApi;

  setUp(() {
    mockApi = MockApi();
    provider = userProvider();
    provider.api = mockApi;
  });

  test('Initial values are set correctly', () {
    expect(provider.Fullname, 'Testing');
    expect(provider.email, '');
    expect(provider.password, '');
    expect(provider.role, '');
    expect(provider.userId, '');
    expect(provider.profileImage, null);
    expect(provider.isGuest, false);
  });

  test('setUserData updates user data and notifies listeners', () {
    final listener = Listener();
    bool didNotify = false;
    provider.addListener(() {
      didNotify = true;
    });

    provider.setUserData(
      userId: '123',
      fullName: 'John Doe',
      email: 'john@example.com',
      password: 'password123',
      role: 'USER',
      profileImage: 'https://example.com/image.jpg',
      isGuest: false,
    );

    expect(provider.userId, '123');
    expect(provider.Fullname, 'John Doe');
    expect(provider.email, 'john@example.com');
    expect(provider.password, 'password123');
    expect(provider.role, 'USER');
    expect(provider.profileImage, 'https://example.com/image.jpg');
    expect(provider.isGuest, false);
    expect(didNotify, true);
  });

  test('fetchGeneralusers updates generalApplications and notifies listeners', () async {
    final mockResponse = {
      'status': 'success',
      'timestamp': 1234567890,
      'data': [
        {
          'applicationId': 'app1',
          'status': {'id': 1, 'name': 'PENDING'},
          'user': {
            'userId': 'user1',
            'fullName': 'Jane Doe',
            'profileImage': 'https://example.com/image2.jpg',
            'role': {'id': 2, 'name': 'USER'},
          },
          'expiryDateTime': '2024-12-31T23:59:59Z',
          'acceptedRejectedBy': null,
          'reason': 'Test reason',
          'verificationCode': '1234',
        }
      ],
    };

    final generalApplications = GeneralApplications.fromJson(mockResponse);


    when(mockApi.getGeneralusersToHost(any)).thenAnswer((_) async => generalApplications);

    bool didNotify = false;
    provider.addListener(() {
      didNotify = true;
    });

    await provider.Generalusers('user1');

    expect(provider.generalApplications, isA<Future<GeneralApplications>>());
    final fetchedGeneralApplications = await provider.generalApplications;
    expect(fetchedGeneralApplications?.data.length, 1);
    expect(fetchedGeneralApplications?.data.first.applicationId, 'app1');
    expect(didNotify, true);
  });



  test('clearUser clears user data and notifies listeners', () {
    bool didNotify = false;
    provider.addListener(() {
      didNotify = true;
    });

    provider.clearUser();

    expect(provider.userId, '');
    expect(provider.Fullname, '');
    expect(provider.email, '');
    expect(provider.password, '');
    expect(provider.role, '');
    expect(provider.profileImage, null);
    expect(provider.isGuest, false);
    expect(didNotify, true);
  });
}

class Listener extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
