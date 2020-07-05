import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinks {
  var _firebaseDynamicLinks = FirebaseDynamicLinks.instance;

  Future initDynamicLinks(Function onLink) async {
    final PendingDynamicLinkData data =
        await _firebaseDynamicLinks.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      onLink(deepLink);
    }

    _firebaseDynamicLinks.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        onLink(deepLink);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  Future<String> _createDynamicLink(bool short) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'meme-56742.web.app',
      link: Uri.parse('https://meme56742.page.link/465477'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.meme',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Prueba',
        description: 'This link works whether app is installed or not!',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }
    return url.path;
  }
}

final DynamicLinks dynamicLinks = DynamicLinks();
