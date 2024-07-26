import 'package:mockito/annotations.dart';
import 'package:firstapp/services/api.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/providers/events_providers.dart';
import 'package:image_picker/image_picker.dart';
@GenerateMocks([EventProvider, userProvider, Api,ImagePicker])
void main() {}
