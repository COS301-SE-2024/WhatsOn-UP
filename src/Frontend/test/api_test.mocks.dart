// Mocks generated by Mockito 5.4.4 from annotations
// in firstapp/test/api_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:typed_data' as _i8;
import 'dart:ui' as _i6;

import 'package:firstapp/providers/events_providers.dart' as _i3;
import 'package:firstapp/providers/user_provider.dart' as _i7;
import 'package:firstapp/services/api.dart' as _i2;
import 'package:firstapp/widgets/event_card.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i9;

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

class _FakeApi_0 extends _i1.SmartFake implements _i2.Api {
  _FakeApi_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [EventProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockEventProvider extends _i1.Mock implements _i3.EventProvider {
  MockEventProvider() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Api get api => (super.noSuchMethod(
        Invocation.getter(#api),
        returnValue: _FakeApi_0(
          this,
          Invocation.getter(#api),
        ),
      ) as _i2.Api);

  @override
  set api(_i2.Api? _api) => super.noSuchMethod(
        Invocation.setter(
          #api,
          _api,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<List<_i5.Event>> get eventsHome => (super.noSuchMethod(
        Invocation.getter(#eventsHome),
        returnValue: _i4.Future<List<_i5.Event>>.value(<_i5.Event>[]),
      ) as _i4.Future<List<_i5.Event>>);

  @override
  _i4.Future<List<_i5.Event>> get eventsRsvp => (super.noSuchMethod(
        Invocation.getter(#eventsRsvp),
        returnValue: _i4.Future<List<_i5.Event>>.value(<_i5.Event>[]),
      ) as _i4.Future<List<_i5.Event>>);

  @override
  List<_i5.Event> get eventsSaved => (super.noSuchMethod(
        Invocation.getter(#eventsSaved),
        returnValue: <_i5.Event>[],
      ) as List<_i5.Event>);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);

  @override
  _i4.Future<void> refreshEvents() => (super.noSuchMethod(
        Invocation.method(
          #refreshEvents,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> refreshRSVPEvents(String? userId) => (super.noSuchMethod(
        Invocation.method(
          #refreshRSVPEvents,
          [userId],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  void fetchfortheFirstTimeRsvp(String? userId) => super.noSuchMethod(
        Invocation.method(
          #fetchfortheFirstTimeRsvp,
          [userId],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<void> addEventHome(Map<String, dynamic>? eventData) =>
      (super.noSuchMethod(
        Invocation.method(
          #addEventHome,
          [eventData],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  void addEventsHome(List<_i5.Event>? events) => super.noSuchMethod(
        Invocation.method(
          #addEventsHome,
          [events],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<void> removeEventHome(_i5.Event? event) => (super.noSuchMethod(
        Invocation.method(
          #removeEventHome,
          [event],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  void addEventRSVP(_i5.Event? event) => super.noSuchMethod(
        Invocation.method(
          #addEventRSVP,
          [event],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void addEventsRSVP(List<_i5.Event>? events) => super.noSuchMethod(
        Invocation.method(
          #addEventsRSVP,
          [events],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeEventRSVP(_i5.Event? event) => super.noSuchMethod(
        Invocation.method(
          #removeEventRSVP,
          [event],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void addEventSaved(_i5.Event? event) => super.noSuchMethod(
        Invocation.method(
          #addEventSaved,
          [event],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeEventSaved(_i5.Event? event) => super.noSuchMethod(
        Invocation.method(
          #removeEventSaved,
          [event],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<_i5.Event?> getEventById(String? id) => (super.noSuchMethod(
        Invocation.method(
          #getEventById,
          [id],
        ),
        returnValue: _i4.Future<_i5.Event?>.value(),
      ) as _i4.Future<_i5.Event?>);

  @override
  _i4.Future<void> EditEventName(
    String? id,
    String? eventName,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #EditEventName,
          [
            id,
            eventName,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  void EditEventDescription(
    String? id,
    String? Description,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #EditEventDescription,
          [
            id,
            Description,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<void> EditEventLocation(
    String? id,
    String? Location,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #EditEventLocation,
          [
            id,
            Location,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> EditEventMaxParticipants(
    String? id,
    int? maxParticipants,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #EditEventMaxParticipants,
          [
            id,
            maxParticipants,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  void EditEventsIsPrivate(
    String? id,
    bool? isPrivate,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #EditEventsIsPrivate,
          [
            id,
            isPrivate,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void EditEventStartTime(
    String? id,
    DateTime? startTime,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #EditEventStartTime,
          [
            id,
            startTime,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void EditEventEndTime(
    String? id,
    DateTime? endTime,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #EditEventEndTime,
          [
            id,
            endTime,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void addListener(_i6.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeListener(_i6.VoidCallback? listener) => super.noSuchMethod(
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

/// A class which mocks [userProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockuserProvider extends _i1.Mock implements _i7.userProvider {
  MockuserProvider() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set profileImage(_i8.Uint8List? _profileImage) => super.noSuchMethod(
        Invocation.setter(
          #profileImage,
          _profileImage,
        ),
        returnValueForMissingStub: null,
      );

  @override
  String get Fullname => (super.noSuchMethod(
        Invocation.getter(#Fullname),
        returnValue: _i9.dummyValue<String>(
          this,
          Invocation.getter(#Fullname),
        ),
      ) as String);

  @override
  String get email => (super.noSuchMethod(
        Invocation.getter(#email),
        returnValue: _i9.dummyValue<String>(
          this,
          Invocation.getter(#email),
        ),
      ) as String);

  @override
  String get password => (super.noSuchMethod(
        Invocation.getter(#password),
        returnValue: _i9.dummyValue<String>(
          this,
          Invocation.getter(#password),
        ),
      ) as String);

  @override
  String get role => (super.noSuchMethod(
        Invocation.getter(#role),
        returnValue: _i9.dummyValue<String>(
          this,
          Invocation.getter(#role),
        ),
      ) as String);

  @override
  String get userId => (super.noSuchMethod(
        Invocation.getter(#userId),
        returnValue: _i9.dummyValue<String>(
          this,
          Invocation.getter(#userId),
        ),
      ) as String);

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
  set profileimage(_i8.Uint8List? value) => super.noSuchMethod(
        Invocation.setter(
          #profileimage,
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
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);

  @override
  void addListener(_i6.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeListener(_i6.VoidCallback? listener) => super.noSuchMethod(
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

/// A class which mocks [Api].
///
/// See the documentation for Mockito's code generation for more information.
class MockApi extends _i1.Mock implements _i2.Api {
  MockApi() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get jwtKey => (super.noSuchMethod(
        Invocation.getter(#jwtKey),
        returnValue: _i9.dummyValue<String>(
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
        returnValue: _i9.dummyValue<String>(
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
  _i4.Future<Map<String, dynamic>> loginUser(
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
            _i4.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i4.Future<Map<String, dynamic>>);

  @override
  _i4.Future<Map<String, dynamic>> getUserDetails() => (super.noSuchMethod(
        Invocation.method(
          #getUserDetails,
          [],
        ),
        returnValue:
            _i4.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i4.Future<Map<String, dynamic>>);

  @override
  _i4.Future<List<_i5.Event>> getAllEvents() => (super.noSuchMethod(
        Invocation.method(
          #getAllEvents,
          [],
        ),
        returnValue: _i4.Future<List<_i5.Event>>.value(<_i5.Event>[]),
      ) as _i4.Future<List<_i5.Event>>);

  @override
  _i4.Future<List<dynamic>> getRSVPEvents(String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getRSVPEvents,
          [userId],
        ),
        returnValue: _i4.Future<List<dynamic>>.value(<dynamic>[]),
      ) as _i4.Future<List<dynamic>>);

  @override
  _i4.Future<Map<String, dynamic>> postChangeUser(
    String? name,
    String? profileImage,
    String? userId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #postChangeUser,
          [
            name,
            profileImage,
            userId,
          ],
        ),
        returnValue:
            _i4.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i4.Future<Map<String, dynamic>>);

  @override
  _i4.Future<Map<String, dynamic>> updatePassword(
    String? password,
    String? userId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updatePassword,
          [
            password,
            userId,
          ],
        ),
        returnValue:
            _i4.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i4.Future<Map<String, dynamic>>);

  @override
  _i4.Future<Map<String, dynamic>> createEvent({
    required String? title,
    required String? description,
    required DateTime? startDate,
    required DateTime? endDate,
    required String? location,
    int? maxParticipants,
    String? metadata,
    bool? isPrivate = false,
    List<String>? media,
    required String? userId,
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
            #location: location,
            #maxParticipants: maxParticipants,
            #metadata: metadata,
            #isPrivate: isPrivate,
            #media: media,
            #userId: userId,
          },
        ),
        returnValue:
            _i4.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i4.Future<Map<String, dynamic>>);

  @override
  _i4.Future<Map<String, dynamic>> rsvpEvent(
    String? eventId,
    String? UserId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #rsvpEvent,
          [
            eventId,
            UserId,
          ],
        ),
        returnValue:
            _i4.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i4.Future<Map<String, dynamic>>);

  @override
  _i4.Future<Map<String, dynamic>> DeletersvpEvent(
    String? eventId,
    String? UserId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #DeletersvpEvent,
          [
            eventId,
            UserId,
          ],
        ),
        returnValue:
            _i4.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i4.Future<Map<String, dynamic>>);

  @override
  _i4.Future<Map<String, dynamic>> DeleteEvent(
    String? eventId,
    String? userid,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #DeleteEvent,
          [
            eventId,
            userid,
          ],
        ),
        returnValue:
            _i4.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i4.Future<Map<String, dynamic>>);

  @override
  _i4.Future<Map<String, dynamic>> postUsername(
    String? username,
    String? userid,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #postUsername,
          [
            username,
            userid,
          ],
        ),
        returnValue:
            _i4.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i4.Future<Map<String, dynamic>>);

  @override
  _i4.Future<Map<String, dynamic>> getUser(String? userid) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUser,
          [userid],
        ),
        returnValue:
            _i4.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i4.Future<Map<String, dynamic>>);

  @override
  _i4.Future<Map<String, dynamic>> updateEvent({
    required String? userId,
    required String? eventId,
    required String? title,
    required String? description,
    required DateTime? startDate,
    required DateTime? endDate,
    required String? location,
    int? maxParticipants,
    String? metadata,
    bool? isPrivate = false,
    List<String>? media,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateEvent,
          [],
          {
            #userId: userId,
            #eventId: eventId,
            #title: title,
            #description: description,
            #startDate: startDate,
            #endDate: endDate,
            #location: location,
            #maxParticipants: maxParticipants,
            #metadata: metadata,
            #isPrivate: isPrivate,
            #media: media,
          },
        ),
        returnValue:
            _i4.Future<Map<String, dynamic>>.value(<String, dynamic>{}),
      ) as _i4.Future<Map<String, dynamic>>);
}
