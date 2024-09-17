

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/surveys/SurveyChooseCat_screen.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/services/api.dart';
import 'package:firstapp/widgets/event_card.dart';

import 'api_test.mocks.dart';



void main() {
  late MockuserProvider mockUserProvider;

  late MockApi mockApi;

  setUp(() {
    mockUserProvider = MockuserProvider();
    mockApi = MockApi();

    when(mockUserProvider.userId).thenReturn('test_user_id');
    when(mockUserProvider.Fullname).thenReturn('User Name');
    when(mockUserProvider.email).thenReturn('user@gmail.com');
    when(mockUserProvider.password).thenReturn('password123');
    when(mockUserProvider.role).thenReturn('GENERAL');
    when(mockApi.getCategories(userId:'userId')).thenAnswer((_) async {
      return [
        Category(id: '59ea9cf3-3764-403f-a9b0-01b6a86476ea', name: 'Film Screening'),
        Category(id: '6981b933-eda9-47c0-b5e6-933d03be60ff', name: 'Food Festival'),
        Category(id: '43f10fe6-75f6-451e-9cb4-6e47a2360f85', name: 'Dance Performance'),
      ];
    });
  });

  testWidgets('SurveyScreen displays loading spinner while fetching categories', (WidgetTester tester) async {
    when(mockApi.getCategories(userId: anyNamed('userId'))).thenAnswer((_) async {


      return [];
    });
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<userProvider>(
            create: (_) => mockUserProvider,
          ),
          Provider<Api>(
            create: (_) => mockApi,
          ),
        ],
        child: const MaterialApp(
          home: SurveyScreen(),
        ),
      ),
    );

    expect(find.byType(SpinKitPianoWave), findsOneWidget);
  });

  testWidgets('SurveyScreen displays categories after fetching', (WidgetTester tester) async {

    final categories = [Category(id: 'id1', name: 'Category 1')];
    when(mockApi.getCategories(userId: anyNamed('userId'))).thenAnswer((_) async => categories);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<userProvider>(
            create: (_) => mockUserProvider,
          ),
          Provider<Api>(
            create: (_) => mockApi,
          ),
        ],
        child: const MaterialApp(
          home: SurveyScreen(),
        ),
      ),
    );
    expect(find.byType(SpinKitPianoWave), findsOneWidget);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Category 1'));
    expect(find.byType(SpinKitPianoWave), findsNothing);
  });

  testWidgets('SurveyScreen displays error message if fetching categories fails', (WidgetTester tester) async {
    when(mockApi.getCategories(userId: anyNamed('userId'))).thenThrow(Exception('Failed to fetch'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<userProvider>(
            create: (_) => mockUserProvider,
          ),
          Provider<Api>(
            create: (_) => mockApi,
          ),
        ],
        child: const MaterialApp(
          home: SurveyScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Failed to load categories'), findsOneWidget);
  });



}
