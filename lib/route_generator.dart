import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/options.dart';
import 'package:flutter_translate/flutter_translate.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/options':
        return MaterialPageRoute(
          builder: (_) => const OptionsPage(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(translate('404')),
        ),
      );
    });
  }
}
