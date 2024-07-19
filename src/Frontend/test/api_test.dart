import 'package:mockito/annotations.dart';
import 'package:firstapp/services/api.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/providers/events_providers.dart';
@GenerateMocks([EventProvider, userProvider, Api])
void main() {}
