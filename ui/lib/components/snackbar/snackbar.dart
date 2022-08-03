import 'dart:async';
import 'dart:html';

enum SnackbarNotificationType { info, success, warning, error }

class SnackbarView {
  DivElement snackbarElement;
  DivElement _contents;
  int secondsOnScreen;

  Timer _timer;

  static const SECONDS_ON_SCREEN = 10;

  /// The length of the animation in milliseconds.
  /// This must match the animation length set in snackbar.css
  static const ANIMATION_LENGTH_MS = 200;

  SnackbarView() {
    snackbarElement = new DivElement()
      ..id = 'snackbar'
      ..classes.add('hidden')
      ..title = 'Click to close notification.'
      ..onClick.listen((_) => hideSnackbar());

    _contents = new DivElement()..classes.add('contents');
    snackbarElement.append(_contents);
  }

  showSnackbar(String message, SnackbarNotificationType type) {
    var validator = NodeValidatorBuilder()
        ..allowHtml5()
        ..allowNavigation(new KatikatiUrlPolicy())
        ..allowTextElements();
    _contents.setInnerHtml(message, validator: validator);
    snackbarElement.classes.remove('hidden');
    snackbarElement.setAttribute('type', type.toString().replaceAll('SnackbarNotificationType.', ''));
    _timer?.cancel();
    _timer = new Timer(new Duration(seconds: SECONDS_ON_SCREEN), () => hideSnackbar());
  }

  hideSnackbar() {
    snackbarElement.classes.toggle('hidden', true);
    snackbarElement.attributes.remove('type');
    // Remove the contents after the animation ends
    new Timer(new Duration(milliseconds: ANIMATION_LENGTH_MS), () => _contents.text = '');
  }
}

class KatikatiUrlPolicy implements UriPolicy {
  KatikatiUrlPolicy();

  RegExp regex = new RegExp(r'(?:http://|https://|//)?katikati.world/.*');

  bool allowsUri(String uri) {
    return regex.hasMatch(uri);
  }
}
