import 'dart:async';
import 'dart:html';

enum SnackbarNotificationType { info, success, warning, error }

class SnackbarView {
  DivElement snackbarElement;
  DivElement _contents;
  int secondsOnScreen;

  /// The length of the animation in milliseconds.
  /// This must match the animation length set in snackbar.css
  static const ANIMATION_LENGTH_MS = 200;

  SnackbarView({int this.secondsOnScreen = 3}) {
    snackbarElement = new DivElement()
      ..id = 'snackbar'
      ..classes.add('hidden')
      ..title = 'Click to close notification.'
      ..onClick.listen((_) => hideSnackbar());

    _contents = new DivElement()..classes.add('contents');
    snackbarElement.append(_contents);
  }

  showSnackbar(String message, SnackbarNotificationType type) {
    _contents.text = message;
    snackbarElement.classes.remove('hidden');
    snackbarElement.setAttribute(
        'type', type.toString().replaceAll('SnackbarNotificationType.', ''));
    new Timer(new Duration(seconds: secondsOnScreen), () => hideSnackbar());
  }

  hideSnackbar() {
    snackbarElement.classes.toggle('hidden', true);
    snackbarElement.attributes.remove('type');
    // Remove the contents after the animation ends
    new Timer(new Duration(milliseconds: ANIMATION_LENGTH_MS),
        () => _contents.text = '');
  }
}
