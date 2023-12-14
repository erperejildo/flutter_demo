import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_demo/main.dart';

class Helpers {
  static getSavedLanguage(BuildContext context) {
    var language = prefs.getString('language');
    if (language == null) {
      language = Platform.localeName.split('_')[0]; // default phone language
      prefs.setString('language', language);
    }
    return Locale(language, '');
  }
}
