import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/audio/sounds.dart';
import 'package:flutter_demo/main.dart';
import 'package:flutter_demo/providers/ads.dart';
import 'package:flutter_demo/providers/auth.dart';
import 'package:flutter_demo/widgets/admob.dart';
import 'package:flutter_demo/widgets/firebase.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';
import 'package:audioplayers/audioplayers.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late AnimationController appTitleController;
  late AudioPlayer backgroundPlayer = AudioPlayer();
  late bool _music;

  @override
  void initState() {
    super.initState();
    initMusic();
    Provider.of<Ads>(context, listen: false).initAds();
  }

  void initMusic() async {
    _music = prefs.getBool('music')!;
    if (!_music) return;

    sounds.playBackground();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Provider.of<Auth>(context).auth.currentUser != null
            ? photoURL()
            : null,
        title: Provider.of<Auth>(context).auth.currentUser != null
            ? Text(
                Provider.of<Auth>(context).auth.currentUser?.email ?? '',
                style: const TextStyle(fontSize: 15),
              )
            : null,
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
              // ignore: prefer_const_constructors
              Firebase(),
              // ignore: prefer_const_constructors
              Admob(),
            ],
          ),
        ),
      ),
    );
  }

  Widget photoURL() {
    // as an example, we are getting the email from Google's API
    // but the photoURL, it's the one we have saved in Firestore (1st it's also from Google)

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(Provider.of<Auth>(context).auth.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.hasData && snapshot.data!.exists) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data['photoURL']),
            ),
          );
        } else {
          return const Text('User does not exist');
        }
      },
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
      color: Theme.of(context).primaryColor,
      child: const TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Colors.white,
        tabs: [
          Tab(
            icon: Icon(UniconsLine.grin),
          ),
          Tab(
            icon: Icon(UniconsLine.user),
          ),
          Tab(
            icon: Icon(UniconsLine.coins),
          ),
        ],
      ),
    );
  }
}
