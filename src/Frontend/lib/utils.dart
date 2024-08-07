
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


pickImage(ImageSource source) async{
final ImagePicker _imagePicker= ImagePicker();
XFile? _file= await _imagePicker.pickImage(source: source);
if (_file!=null){
  return await _file.readAsBytes();
}
print("No images Selected");
}


String formatDateTime(String? dateTimeString) {
  if(dateTimeString == null) {
    return 'no date';
  }
  DateTime dateTime = DateTime.parse(dateTimeString);
  DateFormat formatter = DateFormat('MMM d, yyyy h:mm a');
  return formatter.format(dateTime);
}