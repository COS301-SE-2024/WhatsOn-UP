import 'dart:js' as js;

void loadGoogleMaps(String apiKey) {
      js.context.callMethod('loadGoogleMaps', [apiKey]);

}