import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final adBannerId =
    Platform.isAndroid ? 'ca-app-pub-2945024608555072/7797030700' : 'TODO';
final adRewardedId =
    Platform.isAndroid ? 'ca-app-pub-2945024608555072/2878911798' : 'TODO';

class Ads extends ChangeNotifier {
  // bool showAds = true; // for a paid app we could save with shared_preferences this state and hide the ads
  BannerAd? adBanner;
  bool adBannerLoaded = false;
  RewardedAd? adRewarded;
  bool rewarded = false;

  initAds() async {
    loadBanner();
    loadRewarded();
  }

  void loadBanner() {
    adBanner = BannerAd(
      adUnitId: adBannerId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          adBannerLoaded = true;
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  Widget showBanner() {
    if (!adBannerLoaded) return Container();

    return SizedBox(
      width: adBanner!.size.width.toDouble(),
      height: adBanner!.size.height.toDouble(),
      child: AdWidget(ad: adBanner!),
    );
  }

  void loadRewarded() {
    RewardedAd.load(
      adUnitId: adRewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          adRewarded = ad;
          notifyListeners();
        },
        onAdFailedToLoad: (LoadAdError error) {},
      ),
    );
  }

  Future<void> showRewarded() async {
    if (adRewarded == null) return;

    await adRewarded?.show(
      onUserEarnedReward: (ad, RewardItem reward) {
        rewarded = true;
        notifyListeners();
      },
    );
  }
}

final Ads ads = Ads();
