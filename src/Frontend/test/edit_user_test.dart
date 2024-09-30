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
  test('setGuestUser -see if it gets populated', () {
    final listener = Listener();
    bool didNotify = false;
    provider.addListener(() {
      didNotify = true;
    });
    provider.setGuestUser();


    expect(provider.userId, 'guest');
    expect(provider.Fullname, 'Guest User');
    expect(provider.email, '');
    expect(provider.password, '');
    expect(provider.role, 'GUEST');
    expect(provider.profileImage, null);
    expect(provider.isGuest, true);
    expect(didNotify, true);
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
  test('Testing if setting up other parameters work', () {
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
provider.isGuest = true;
provider.Fullname = 'John Doe1';
provider.email = 'john@example.com1';
provider.password = 'password1234';
provider.role = 'ADMIN';
provider.profileImage = 'https://example.com/image1.jpg';
provider.userId = '1234';
provider.JWT = '1234';
    expect(provider.userId, '1234');
    expect(provider.Fullname, 'John Doe1');
    expect(provider.email, 'john@example.com1');
    expect(provider.password, 'password1234');
    expect(provider.role, 'ADMIN');
    expect(provider.profileImage, 'https://example.com/image1.jpg');
    expect(provider.isGuest, true);
    expect(provider.JWT, '1234');
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




  test('clearUser does not notify listeners if data is already cleared', () {
    // Set initial data
    provider.setUserData(
      userId: '123',
      fullName: 'John Doe',
      email: 'john@example.com',
      password: 'password123',
      role: 'USER',
      profileImage: 'https://example.com/image.jpg',
      isGuest: false,
    );

    bool didNotify = false;
    provider.addListener(() {
      didNotify = true;
    });


    provider.clearUser();


    expect(didNotify, isTrue);


    didNotify = false;


    provider.clearUser();
    expect(didNotify, isFalse);
  });

  test('fetchGeneralusers updates generalApplications with empty data', () async {
    final emptyResponse = {
      'status': 'success',
      'timestamp': 1234567890,
      'data': [],
    };

    final emptyGeneralApplications = GeneralApplications.fromJson(emptyResponse);

    when(mockApi.getGeneralusersToHost(any)).thenAnswer((_) async => emptyGeneralApplications);

    bool didNotify = false;
    provider.addListener(() {
      didNotify = true;
    });

    await provider.Generalusers('user1');

    expect(provider.generalApplications, isA<Future<GeneralApplications>>());
    final fetchedGeneralApplications = await provider.generalApplications;
    expect(fetchedGeneralApplications?.data.length, 0);
    expect(didNotify, true);
  });



}

class Listener extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
