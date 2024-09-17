import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  print("No images Selected");
}

String formatDateTime(String? dateTimeString) {
  if (dateTimeString == null || dateTimeString.isEmpty) {
    return 'no date';
  }

  try {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat formatter = DateFormat('MMM d, yyyy h:mm a');
    return formatter.format(dateTime.toLocal());
  } catch (e) {
    print('Error parsing date: $e');
    return 'Invalid date';
  }
}
