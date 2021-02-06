import 'dart:async';
import 'dart:html';

class BannerView {
  DivElement bannerElement;
  DivElement _contents;

  /// The length of the animation in milliseconds.
  /// This must match the animation length set in banner.css
  static const ANIMATION_LENGTH_MS = 200;

  BannerView() {
    bannerElement = new DivElement()
      ..id = 'banner'
      ..classes.add('hidden');

    _contents = new DivElement()..classes.add('contents');
    bannerElement.append(_contents);
  }

  showBanner(String message) {
    _contents.text = message;
    bannerElement.classes.remove('hidden');
  }

  hideBanner() {
    bannerElement.classes.add('hidden');
    // Remove the contents after the animation ends
    new Timer(new Duration(milliseconds: ANIMATION_LENGTH_MS), () => _contents.text = '');
  }
}
