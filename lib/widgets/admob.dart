import 'package:flutter/material.dart';
import 'package:flutter_demo/providers/ads.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class Admob extends StatefulWidget {
  const Admob({super.key});

  @override
  State<Admob> createState() => _AdmobState();
}

class _AdmobState extends State<Admob> {
  dynamic ads;

  @override
  void didChangeDependencies() {
    ads = Provider.of<Ads>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (ads.adBannerLoaded) {
      ads.adBanner!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
          child: Column(
        children: [
          Text(
            translate('admob.welcome'),
            style: const TextStyle(fontSize: 20),
          ),
          Provider.of<Ads>(context).showBanner(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(translate('admob.get_rewards')),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<Ads>(context, listen: false).showRewarded();
            },
            child: Text(translate('admob.watch_video')),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(translate('admob.confirm_reward')),
          ),
          Text(translate(Provider.of<Ads>(context).rewarded ? 'yes' : 'no')),
        ],
      )),
    );
  }
}
