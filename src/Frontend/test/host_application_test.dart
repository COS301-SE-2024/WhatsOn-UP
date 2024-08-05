import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firstapp/pages/host_application.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'api_test.mocks.dart';


void main() {
  group('HostApplicationPage Tests', () {
    late MockuserProvider mockUserProvider;

    setUp(() {
      mockUserProvider = MockuserProvider();
      
      when(mockUserProvider.userId).thenReturn('test_user_id');
      when(mockUserProvider.Fullname).thenReturn('User Name');
      when(mockUserProvider.email).thenReturn('user@gmail.com');
      when(mockUserProvider.password).thenReturn('password123');
      when(mockUserProvider.role).thenReturn('GENERAL');
    });

    Widget createHostApplicationPage() {
      return MaterialApp(
          home: ChangeNotifierProvider<userProvider>.value(
            value: mockUserProvider,
            child: HostApplicationPage(),
          ),
        ); 
    }

    testWidgets('should display all form fields for student', (WidgetTester tester) async {
      await tester.pumpWidget(createHostApplicationPage());

      expect(find.text('Apply to become a host'), findsOneWidget);
      expect(find.text('Are you a university student?'), findsOneWidget);
      expect(find.text('Student Email'), findsOneWidget);
      expect(find.text('Reason for becoming a host'), findsOneWidget);
      expect(find.text('Duration'), findsOneWidget);
      expect(find.text('Start Date'), findsOneWidget);
      expect(find.text('Submit Application'), findsOneWidget);
    });

    testWidgets('should display permission sticker upload for non-student', (WidgetTester tester) async {
      await tester.pumpWidget(createHostApplicationPage());

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(find.text('Upload Permission Sticker'), findsOneWidget);
      expect(find.text('Choose Image'), findsOneWidget);
      expect(find.text('Student Email'), findsNothing);
    });

    testWidgets('should show error when form is submitted without required fields', (WidgetTester tester) async {
      await tester.pumpWidget(createHostApplicationPage());

      await tester.tap(find.text('Submit Application'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your student email'), findsOneWidget);
      expect(find.text('Please provide a reason'), findsOneWidget);
    });

    testWidgets('should open date picker when tapping on start date', (WidgetTester tester) async {
      await tester.pumpWidget(createHostApplicationPage());

      await tester.tap(find.text('Start Date'));
      await tester.pumpAndSettle();

      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('should change duration when selecting from dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(createHostApplicationPage());

      await tester.tap(find.text('1 week'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('1 month').last);
      await tester.pumpAndSettle();

      expect(find.text('1 month'), findsWidgets);
    });

    testWidgets('should attempt to submit form when all fields are filled', (WidgetTester tester) async {
      await tester.pumpWidget(createHostApplicationPage());

      await tester.enterText(find.byType(TextFormField).at(0), 'test@tuks.co.za');
      await tester.enterText(find.byType(TextFormField).at(1), 'Test reason');

      await tester.tap(find.text('Submit Application'));
      await tester.pumpAndSettle();
    });
  });
}