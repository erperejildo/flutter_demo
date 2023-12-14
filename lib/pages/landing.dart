import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:unicons/unicons.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(UniconsLine.bars),
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/options',
              );
            },
          )
        ],
      ),
      body: appTitle(),
    );
  }

  Widget appTitle() {
    return JelloIn(
      child: Center(
        child: Text(
          translate('app_title'),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 90),
        ),
      ),
    );
  }
}
