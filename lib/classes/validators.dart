import 'package:flutter_translate/flutter_translate.dart';

class Validators {
  static checkInput(String value) {
    value = value.replaceAll(RegExp(' +'), ' ');
    if (value.isEmpty || value == ' ' || value == '') {
      return translate('validators.fill_field');
    }
    return null;
  }

  static checkUrl(String value) {
    value = value.replaceAll(RegExp(' +'), ' ');
    if (value.isEmpty || value == ' ' || value == '') {
      return translate('validators.fill_field');
    }
    bool validURL = Uri.parse(value).isAbsolute;
    if (validURL != true) {
      return translate('validators.url');
    }
    return null;
  }
}
