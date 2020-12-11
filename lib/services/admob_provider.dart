
// const String testDevice = 'ca-app-pub-9818237769586714~9232332501';

class AdMobStatic{
  static bool testing = false;

  static String appId = 'ca-app-pub-9818237769586714~9232332501';

  static String realAdsBannerUnitId = 'ca-app-pub-9818237769586714/6888174539';
  static String realAdsInterstitialUnitId = 'ca-app-pub-9818237769586714/4276546962';
  static String realAdsNativeUnitId = 'ca-app-pub-9818237769586714/5979483200';


  static String bannerAdUnitId =
      testing ? 'ca-app-pub-9818237769586714/6888174539' : realAdsBannerUnitId;

  static String interstitialAdUnitId =
      testing ? 'cca-app-pub-9818237769586714/4276546962' : realAdsInterstitialUnitId;

  static String nativeAdUnitId =
      testing ? 'ca-app-pub-9818237769586714/5979483200' : realAdsNativeUnitId;
}