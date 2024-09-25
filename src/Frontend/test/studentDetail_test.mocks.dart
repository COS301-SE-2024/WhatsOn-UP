// Mocks generated by Mockito 5.4.4 from annotations
// in firstapp/test/studentDetail_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;
import 'dart:typed_data' as _i8;
import 'dart:ui' as _i9;

import 'package:firstapp/providers/user_provider.dart' as _i2;
import 'package:firstapp/services/api.dart' as _i3;
import 'package:firstapp/widgets/event_card.dart' as _i6;
import 'package:firstapp/widgets/notification_card.dart' as _i7;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeGeneralApplications_0 extends _i1.SmartFake
    implements _i2.GeneralApplications {
  _FakeGeneralApplications_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeApi_1 extends _i1.SmartFake implements _i3.Api {
  _FakeApi_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Api].
///
/// See the documentation for Mockito's code generation for more information.
class MockApi extends _i1.Mock implements _i3.Api {
  MockApi() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get jwtKey => (super.noSuchMethod(
        Invocation.getter(#jwtKey),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#jwtKey),
        ),
      ) as String);

  @override
  set jwtKey(String? _jwtKey) => super.noSuchMethod(
        Invocation.setter(
          #jwtKey,
          _jwtKey,
        ),
        returnValueForMissingStub: null,
      );

  @override
  String get refreshToken => (super.noSuchMethod(
        Invocation.getter(#refreshToken),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#refreshToken),
        ),
      ) as String);

  @override
  set refreshToken(String? _refreshToken) => super.noSuchMethod(
        Invocation.setter(
          #refreshToken,
          _refreshToken,
        ),
        returnValueForMissingStub: null,
      );

  @override
  set JWT(dynamic _JWT) => super.noSuchMethod(
        Invocation.setter(
          #JWT,
          _JWT,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.Future<Map<String, dynamic>> loginUser(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #loginUser,
          [
            email,
            password,
          ],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> getUserDetails() => (super.noSuchMethod(
        Invocation.method(
          #getUserDetails,
          [],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<List<_i6.Event>> getAllEvents(String? JWT) => (super.noSuchMethod(
        Invocation.method(
          #getAllEvents,
          [JWT],
        ),
        returnValue: _i5.Future<List<_i6.Event>>.value(<_i6.Event>[]),
      ) as _i5.Future<List<_i6.Event>>);

  @override
  _i5.Future<List<_i6.Event>> getAllSavedEvents(String? JWT) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllSavedEvents,
          [JWT],
        ),
        returnValue: _i5.Future<List<_i6.Event>>.value(<_i6.Event>[]),
      ) as _i5.Future<List<_i6.Event>>);

  @override
  _i5.Future<List<_i6.Event>> getRecommendedEvents(String? JWT) =>
      (super.noSuchMethod(
        Invocation.method(
          #getRecommendedEvents,
          [JWT],
        ),
        returnValue: _i5.Future<List<_i6.Event>>.value(<_i6.Event>[]),
      ) as _i5.Future<List<_i6.Event>>);

  @override
  _i5.Future<List<dynamic>> getRSVPEvents(String? JWT) => (super.noSuchMethod(
        Invocation.method(
          #getRSVPEvents,
          [JWT],
        ),
        returnValue: _i5.Future<List<dynamic>>.value(<dynamic>[]),
      ) as _i5.Future<List<dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> postChangeUser(
    String? name,
    String? JWT,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #postChangeUser,
          [
            name,
            JWT,
          ],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> updatePassword(
    String? password,
    String? JWT,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updatePassword,
          [
            password,
            JWT,
          ],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> createEvent({
    required String? title,
    required String? description,
    required DateTime? startDate,
    required DateTime? endDate,
    required String? locationId,
    int? maxParticipants,
    Map<String, String>? metadata,
    bool? isPrivate,
    required String? JWT,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #createEvent,
          [],
          {
            #title: title,
            #description: description,
            #startDate: startDate,
            #endDate: endDate,
            #locationId: locationId,
            #maxParticipants: maxParticipants,
            #metadata: metadata,
            #isPrivate: isPrivate,
            #JWT: JWT,
          },
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> rsvpEvent(
    String? eventId,
    String? JWT,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #rsvpEvent,
          [
            eventId,
            JWT,
          ],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> putSavedEvent(
    String? eventId,
    String? JWT,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #putSavedEvent,
          [
            eventId,
            JWT,
          ],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> DeleteSavedEvent(
    String? eventId,
    String? JWT,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #DeleteSavedEvent,
          [
            eventId,
            JWT,
          ],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<List<_i7.AppNotification>> getAllNotification(
          {required String? JWT}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllNotification,
          [],
          {#JWT: JWT},
        ),
        returnValue: _i5.Future<List<_i7.AppNotification>>.value(
            <_i7.AppNotification>[]),
      ) as _i5.Future<List<_i7.AppNotification>>);

  @override
  _i5.Future<Map<String, dynamic>> AcceptInvite({
    String? JWT,
    String? notificationId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #AcceptInvite,
          [],
          {
            #JWT: JWT,
            #notificationId: notificationId,
          },
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> postNotifyUser({
    required String? userId,
    required String? message,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #postNotifyUser,
          [],
          {
            #userId: userId,
            #message: message,
          },
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<_i2.GeneralApplications> getGeneralusersToHost(String? JWT) =>
      (super.noSuchMethod(
        Invocation.method(
          #getGeneralusersToHost,
          [JWT],
        ),
        returnValue: _i5.Future<_i2.GeneralApplications>.value(
            _FakeGeneralApplications_0(
          this,
          Invocation.method(
            #getGeneralusersToHost,
            [JWT],
          ),
        )),
      ) as _i5.Future<_i2.GeneralApplications>);

  @override
  _i5.Future<Map<String, dynamic>> DeletersvpEvent(
    String? eventId,
    String? JWT,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #DeletersvpEvent,
          [
            eventId,
            JWT,
          ],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> DeleteEvent(
    String? eventId,
    String? JWT,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #DeleteEvent,
          [
            eventId,
            JWT,
          ],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> postUsername(
    String? username,
    String? JWT,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #postUsername,
          [
            username,
            JWT,
          ],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> getUser(String? JWT) => (super.noSuchMethod(
        Invocation.method(
          #getUser,
          [JWT],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<List<_i6.Event>> getAllEventsGuest() => (super.noSuchMethod(
        Invocation.method(
          #getAllEventsGuest,
          [],
        ),
        returnValue: _i5.Future<List<_i6.Event>>.value(<_i6.Event>[]),
      ) as _i5.Future<List<_i6.Event>>);

  @override
  _i5.Future<Map<String, dynamic>> updateEvent({
    required String? JWT,
    required String? eventId,
    required String? title,
    required String? description,
    required DateTime? startDate,
    required DateTime? endDate,
    required String? locationId,
    int? maxParticipants,
    Map<String, String>? metadata,
    bool? isPrivate = false,
    List<String>? media,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateEvent,
          [],
          {
            #JWT: JWT,
            #eventId: eventId,
            #title: title,
            #description: description,
            #startDate: startDate,
            #endDate: endDate,
            #locationId: locationId,
            #maxParticipants: maxParticipants,
            #metadata: metadata,
            #isPrivate: isPrivate,
            #media: media,
          },
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> uploadImage(
    _i8.Uint8List? imageBytes,
    String? userid,
    String? JWT,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #uploadImage,
          [
            imageBytes,
            userid,
            JWT,
          ],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> eventUploadImage(
    _i8.Uint8List? mediaBytes,
    String? JWT,
    String? eventId,
    String? originalFilename,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #eventUploadImage,
          [
            mediaBytes,
            JWT,
            eventId,
            originalFilename,
          ],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> applyForHost({
    required String? reason,
    required String? duration,
    required DateTime? fromWhen,
    String? studentEmail,
    _i8.Uint8List? proofImage,
    required String? JWT,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #applyForHost,
          [],
          {
            #reason: reason,
            #duration: duration,
            #fromWhen: fromWhen,
            #studentEmail: studentEmail,
            #proofImage: proofImage,
            #JWT: JWT,
          },
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> broadcastEvent(
    String? eventId,
    String? message,
    String? JWT,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #broadcastEvent,
          [
            eventId,
            message,
            JWT,
          ],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> broadcast(
    String? message,
    String? JWT,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #broadcast,
          [
            message,
            JWT,
          ],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> AcceptApplication({
    required String? JWT,
    required String? applicationId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #AcceptApplication,
          [],
          {
            #JWT: JWT,
            #applicationId: applicationId,
          },
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> DeclineApplication({
    required String? JWT,
    required String? applicationId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #DeclineApplication,
          [],
          {
            #JWT: JWT,
            #applicationId: applicationId,
          },
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> DemoteApplicant({
    required String? JWT,
    required String? userId,
    required String? applicationId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #DemoteApplicant,
          [],
          {
            #JWT: JWT,
            #userId: userId,
            #applicationId: applicationId,
          },
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> Acknowledgeapplication(
          {required String? JWT}) =>
      (super.noSuchMethod(
        Invocation.method(
          #Acknowledgeapplication,
          [],
          {#JWT: JWT},
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<List<_i6.Category>> getCategories({required String? JWT}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCategories,
          [],
          {#JWT: JWT},
        ),
        returnValue: _i5.Future<List<_i6.Category>>.value(<_i6.Category>[]),
      ) as _i5.Future<List<_i6.Category>>);

  @override
  _i5.Future<Map<String, dynamic>> postRecommendationData({
    required String? JWT,
    required Map<String, dynamic>? data,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #postRecommendationData,
          [],
          {
            #JWT: JWT,
            #data: data,
          },
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> rateEvent(
    String? eventId,
    String? JWT,
    int? rating,
    String? comment,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #rateEvent,
          [
            eventId,
            JWT,
            rating,
            comment,
          ],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> deleteEventMedia(
    String? imageName,
    String? JWT,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteEventMedia,
          [
            imageName,
            JWT,
          ],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> deleteNotification(
    String? notificationId,
    String? JWT,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteNotification,
          [
            notificationId,
            JWT,
          ],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> getAllEventsAnalytics(String? JWT) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllEventsAnalytics,
          [JWT],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> getAllHostsAnalytics(String? JWT) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllHostsAnalytics,
          [JWT],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> getHostEventAnalytics(
    String? userId,
    String? JWT,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getHostEventAnalytics,
          [
            userId,
            JWT,
          ],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> getAllPopularEvents(String? JWT) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllPopularEvents,
          [JWT],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<Map<String, dynamic>> getHostPopularEvents(String? JWT) =>
      (super.noSuchMethod(
        Invocation.method(
          #getHostPopularEvents,
          [JWT],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);

  @override
  _i5.Future<void> markSeen(
    String? eventID,
    String? JWT,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #markSeen,
          [
            eventID,
            JWT,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<Map<String, dynamic>> getAutofillData(
    String? JWT,
    String? eventName,
    String? eventDescription,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAutofillData,
          [
            JWT,
            eventName,
            eventDescription,
          ],
        ),
        returnValue:
            _i5.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i5.Future<Map<String, dynamic>>);
}

/// A class which mocks [userProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockuserProvider extends _i1.Mock implements _i2.userProvider {
  MockuserProvider() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Api get api => (super.noSuchMethod(
        Invocation.getter(#api),
        returnValue: _FakeApi_1(
          this,
          Invocation.getter(#api),
        ),
      ) as _i3.Api);

  @override
  set api(_i3.Api? _api) => super.noSuchMethod(
        Invocation.setter(
          #api,
          _api,
        ),
        returnValueForMissingStub: null,
      );

  @override
  set profileimage(String? _profileimage) => super.noSuchMethod(
        Invocation.setter(
          #profileimage,
          _profileimage,
        ),
        returnValueForMissingStub: null,
      );

  @override
  String get Fullname => (super.noSuchMethod(
        Invocation.getter(#Fullname),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#Fullname),
        ),
      ) as String);

  @override
  String get email => (super.noSuchMethod(
        Invocation.getter(#email),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#email),
        ),
      ) as String);

  @override
  String get password => (super.noSuchMethod(
        Invocation.getter(#password),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#password),
        ),
      ) as String);

  @override
  String get role => (super.noSuchMethod(
        Invocation.getter(#role),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#role),
        ),
      ) as String);

  @override
  String get userId => (super.noSuchMethod(
        Invocation.getter(#userId),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#userId),
        ),
      ) as String);

  @override
  bool get isGuest => (super.noSuchMethod(
        Invocation.getter(#isGuest),
        returnValue: false,
      ) as bool);

  @override
  String get JWT => (super.noSuchMethod(
        Invocation.getter(#JWT),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#JWT),
        ),
      ) as String);

  @override
  set JWT(String? value) => super.noSuchMethod(
        Invocation.setter(
          #JWT,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  set generalapplications(_i5.Future<_i2.GeneralApplications>? value) =>
      super.noSuchMethod(
        Invocation.setter(
          #generalapplications,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  set Fullname(String? value) => super.noSuchMethod(
        Invocation.setter(
          #Fullname,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  set email(String? value) => super.noSuchMethod(
        Invocation.setter(
          #email,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  set password(String? value) => super.noSuchMethod(
        Invocation.setter(
          #password,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  set profileImage(String? value) => super.noSuchMethod(
        Invocation.setter(
          #profileImage,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  set role(String? value) => super.noSuchMethod(
        Invocation.setter(
          #role,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  set userId(String? value) => super.noSuchMethod(
        Invocation.setter(
          #userId,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  set isGuest(bool? value) => super.noSuchMethod(
        Invocation.setter(
          #isGuest,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);

  @override
  void setUserData({
    required String? userId,
    required String? fullName,
    required String? email,
    String? password,
    required String? role,
    String? profileImage,
    required bool? isGuest,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #setUserData,
          [],
          {
            #userId: userId,
            #fullName: fullName,
            #email: email,
            #password: password,
            #role: role,
            #profileImage: profileImage,
            #isGuest: isGuest,
          },
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setGuestUser() => super.noSuchMethod(
        Invocation.method(
          #setGuestUser,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void clearUser() => super.noSuchMethod(
        Invocation.method(
          #clearUser,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.Future<void> Generalusers(String? JWT) => (super.noSuchMethod(
        Invocation.method(
          #Generalusers,
          [JWT],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> refreshApplications() => (super.noSuchMethod(
        Invocation.method(
          #refreshApplications,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  void addListener(_i9.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeListener(_i9.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
