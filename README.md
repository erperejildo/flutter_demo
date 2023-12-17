# flutter_demo

This is a Flutter demo app with some examples.

## Getting Started

Tested on Flutter 3.16.4 but it should work with newer versions as long you keep the same dependencies. Working on Android (emulator and real device).

## Examples:

- [Provider](https://pub.dev/packages/provider):
  - State management solution
  - [Code](https://github.com/erperejildo/flutter_demo/tree/main/lib/providers)

- [Animations](https://pub.dev/packages/animate_do):
  - Simple animation on app title
  - [Code](https://github.com/erperejildo/flutter_demo/blob/main/lib/pages/landing.dart#L121)

- [Shared Preferences](https://docs.flutter.dev/cookbook](https://pub.dev/packages/shared_preferences)https://pub.dev/packages/shared_preferences):
  - Save info about sounds and language in the phone 
  - [Code](https://github.com/erperejildo/flutter_demo/blob/main/lib/pages/options.dart#L24)
 
- [Sounds](https://pub.dev/packages/audioplayers):
  - Play background music 
  - [Code](https://github.com/erperejildo/flutter_demo/blob/main/lib/audio/sounds.dart) 
 
- [Ads](https://pub.dev/packages/google_mobile_ads):
  - Use AdMob to show banners and reward ads  
  - [Code](https://github.com/erperejildo/flutter_demo/blob/main/lib/providers/ads.dart)

- Routing:
  - Define page names to easily move through them  
  - [Code](https://github.com/erperejildo/flutter_demo/blob/main/lib/route_generator.dart)
 
- [Translations](https://pub.dev/packages/flutter_translate):
  - Change app language without restarting it  
  - [Code](https://github.com/erperejildo/flutter_demo/blob/main/lib/pages/options.dart#L49)

- [Icon](https://pub.dev/packages/flutter_launcher_icons):
  - App icon. Generate it with `dart run flutter_launcher_icons:main`
 
- [Splashscreen](https://pub.dev/packages/flutter_native_splash):
  - Loading screen when opening app. Generate it with `dart run flutter_native_splash:create`

- [Email](https://pub.dev/packages/flutter_email_sender):
  - Send email
  - [Code](https://github.com/erperejildo/flutter_demo/blob/main/lib/pages/options.dart#L100)

// TODO: when app is published
// Google Play Games, achievements, leaderboards...

