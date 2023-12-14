import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/firebase.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:unicons/unicons.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late AnimationController appTitleController;

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
      body:
          //  appTitle(),

          DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              appTitle(),
              const Firebase(),
              Container(child: Icon(Icons.directions_bike)),
            ],
          ),
        ),
      ),
    );
  }

  Widget appTitle() {
    return JelloIn(
      controller: (controller) => appTitleController = controller,
      child: Center(
        child: Text(
          translate('app_title'),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 90),
        ),
      ),
    );
  }

  Widget menu() {
    return Container(
      color: Colors.red[900],
      child: const TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Colors.white,
        tabs: [
          Tab(
            icon: Icon(UniconsLine.abacus),
          ),
          Tab(
            icon: Icon(UniconsLine.user),
          ),
          Tab(
            icon: Icon(Icons.account_balance_wallet),
          ),
        ],
      ),
    );
  }
}
