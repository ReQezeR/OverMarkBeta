
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

class AdMobStatic{
  static bool testing = true;

  static String appId = 'ca-app-pub-9818237769586714~9232332501';

  static String realAdsBannerUnitId = 'ca-app-pub-';
  static String realAdsInterstitialUnitId = 'ca-app-pub-9818237769586714/4276546962';
  static String realAdsNativeUnitId = 'ca-app-pub-9818237769586714/5979483200';
  static String realAdsRewardVideoUnitId = 'ca-app-pub-';


  static String bannerAdUnitId =
      testing ? 'ca-app-pub-3940256099942544/6300978111' : realAdsBannerUnitId;

  static String interstitialAdUnitId =
      !testing ? 'ca-app-pub-3940256099942544/1033173712' : realAdsInterstitialUnitId;

  static String nativeAdUnitId =
      !testing ? 'ca-app-pub-3940256099942544/2247696110' : realAdsNativeUnitId;

  static String rewardVideoAdUnitId =
      testing ? 'ca-app-pub-3940256099942544/5224354917' : realAdsRewardVideoUnitId;

  // uncomment if using Google Ads
  // static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  //   testDevices: <String>[],
  //   nonPersonalizedAds: true,
  //   keywords: <String>['gaming', 'flutter'],
  // );
}