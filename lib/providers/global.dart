import 'package:flutter/material.dart';
import 'package:flutter_demo/main.dart';

class Global extends ChangeNotifier {
  bool darkMode() {
    return prefs.getBool('darkMode')!;
  }

  Future<void> changeTheme() async {
    var darkMode = prefs.getBool('darkMode');
    await prefs.setBool('darkMode', !darkMode!);
    notifyListeners();
  }
}

final Global global = Global();
