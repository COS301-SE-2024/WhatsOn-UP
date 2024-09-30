// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mockito/mockito.dart';
// import 'package:provider/provider.dart';
// import 'package:firstapp/pages/editProfile_page.dart';
// import 'package:firstapp/providers/user_provider.dart';
// import 'package:firstapp/services/api.dart';
// import 'api_test.mocks.dart';
// import 'package:image/image.dart' as img;
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:mocktail_image_network/mocktail_image_network.dart';
// void main() {
//   group('EditprofilePage', () {
//     late MockImagePicker mockImagePicker;
//     late MockuserProvider mockUserProvider;
//
//
//     setUp(() {
//       mockUserProvider = MockuserProvider();
//
//       mockImagePicker = MockImagePicker();
//       when(mockUserProvider.Fullname).thenReturn('Test User');
//       when(mockUserProvider.email).thenReturn('user@email.com');
//
//       final placeholderImage = img.Image(width: 20, height: 20);
//       final placeholderImageData = img.encodePng(placeholderImage);
//       String mockImageUrl = 'http://example.com/path/to/placeholder/image.jpg';
//       when(mockUserProvider.profileImage).thenReturn(mockImageUrl);
//
//     });
//
//     Widget createWidgetUnderTest() {
//       return ChangeNotifierProvider<userProvider>(
//         create: (_) => mockUserProvider,
//         child: MaterialApp(
//           home: EditprofilePage(),
//         ),
//       );
//     }
//
//     testWidgets('renders correctly', (WidgetTester tester) async {
//       await tester.pumpWidget(createWidgetUnderTest());
//
//       expect(find.text('Edit Profile'), findsOneWidget);
//       expect(find.text('Save'), findsOneWidget);
//       expect(find.text('Cancel'), findsOneWidget);
//       expect(find.byType(TextFormField), findsNWidgets(1));
//     });
//
//     // testWidgets('select image and update state', (WidgetTester tester) async {
//     //   Uint8List testImage = Uint8List.fromList([0, 0, 0, 0]);
//     //   when(mockImagePicker.pickImage(source: ImageSource.gallery))
//     //       .thenAnswer((_) async => XFile.fromData(testImage));
//     //
//     //   await tester.pumpWidget(createWidgetUnderTest());
//     //
//     //   await tester.tap(find.byIcon(Icons.add_a_photo));
//     //   await tester.pumpAndSettle();
//     //
//     //
//     //   expect(find.byType(MemoryImage), findsOneWidget);
//     // });
//
//
//
//     // testWidgets('shows loading indicator during API call', (WidgetTester tester) async {
//     //   when(mockApi.postChangeUser(any, any, any))
//     //       .thenAnswer((_) async => Future.delayed(Duration(seconds: 2)));
//     //
//     //   await tester.pumpWidget(createWidgetUnderTest());
//     //
//     //   await tester.tap(find.text('Save'));
//     //   await tester.pump();
//     //
//     //
//     //   expect(find.byType(SpinKitPianoWave), findsOneWidget);
//     //
//     //
//     //   await tester.pumpAndSettle();
//     // });
//   });
// }
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/pages/editProfile_page.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'api_test.mocks.dart';
import 'package:image/image.dart' as img;
// import 'package:mocktail/mocktail.dart';
void main() {
  group('EditprofilePage', () {
    late MockImagePicker mockImagePicker;
    late MockuserProvider mockUserProvider;


    setUp(() {
      mockUserProvider = MockuserProvider();

      mockImagePicker = MockImagePicker();
      when(mockUserProvider.Fullname).thenReturn('Test User');
      when(mockUserProvider.email).thenReturn('user@email.com');

      final placeholderImage = img.Image(width: 20, height: 20);
      final placeholderImageData = img.encodePng(placeholderImage);
      String mockImageUrl = 'http://example.com/path/to/placeholder/image.jpg';
      when(mockUserProvider.profileImage).thenReturn(mockImageUrl);

    });

    Widget createWidgetUnderTest() {
      return ChangeNotifierProvider<userProvider>(
        create: (_) => mockUserProvider,
        child:  MaterialApp(
          home: EditprofilePage(),
        ),
      );
    }

    testWidgets('renders correctly', (WidgetTester tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.text('Edit Profile'), findsOneWidget);
        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(1));
      });
    });

    // testWidgets('select image and update state', (WidgetTester tester) async {
    //   Uint8List testImage = Uint8List.fromList([0, 0, 0, 0]);
    //   when(mockImagePicker.pickImage(source: ImageSource.gallery))
    //       .thenAnswer((_) async => XFile.fromData(testImage));
    //
    //   await tester.pumpWidget(createWidgetUnderTest());
    //
    //   await tester.tap(find.byIcon(Icons.add_a_photo));
    //   await tester.pumpAndSettle();
    //
    //
    //   expect(find.byType(MemoryImage), findsOneWidget);
    // });



    // testWidgets('shows loading indicator during API call', (WidgetTester tester) async {
    //   when(mockApi.postChangeUser(any, any, any))
    //       .thenAnswer((_) async => Future.delayed(Duration(seconds: 2)));
    //
    //   await tester.pumpWidget(createWidgetUnderTest());
    //
    //   await tester.tap(find.text('Save'));
    //   await tester.pump();
    //
    //
    //   expect(find.byType(SpinKitPianoWave), findsOneWidget);
    //
    //
    //   await tester.pumpAndSettle();
    // });
  });
}
