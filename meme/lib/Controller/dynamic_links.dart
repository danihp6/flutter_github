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

  Future<String> postDynamicLink(bool short,String authorId,String postId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://meme56742.page.link',
      link: Uri.parse('https://meme56742.page.link?type=post&id=$postId&author=$authorId'),
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
        title: 'Publicación',
        description: 'Link a la publicación',
      ),
    );
    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url =  shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }
    return parameters.uriPrefix +url.path;
  }

    Future<String> userDynamicLink(bool short,String userId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://meme56742.page.link',
      link: Uri.parse('https://meme56742.page.link?type=user&id=$userId'),
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
        title: 'Usuario',
        description: 'Link a el usuario',
      ),
    );
    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url =  shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }
    return parameters.uriPrefix +url.path;
  }
}

final DynamicLinks dynamicLinks = DynamicLinks();
