import 'package:firstapp/providers/notification_providers.dart';
import 'package:mockito/annotations.dart';
import 'package:firstapp/services/api.dart';
import 'package:firstapp/providers/user_provider.dart';
import 'package:firstapp/providers/events_providers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firstapp/widgets/theme_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@GenerateMocks([EventProvider, userProvider, Api,ImagePicker,notificationProvider, ThemeNotifier, Supabase, SupabaseClient, GoTrueClient])
void main() {}
