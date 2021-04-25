import 'dart:html';
import 'dart:async';
import 'package:katikati_ui_lib/components/logger.dart';

var logger = Logger('SidebarIconsView');

class IconButtonView {
  String _id;
  String _assetPath;
  bool _inView;

  ButtonElement renderElement;

  Stream<bool> _onToggle;
  StreamController<bool> _onToggleController;
  Stream<bool> get onToggle => _onToggle;

  IconButtonView(this._id, this._assetPath, this._inView) {
    this._onToggleController = StreamController();
    this._onToggle = _onToggleController.stream;

    var iconElement = ImageElement(src: this._assetPath)..className = "icon-toggle";

    renderElement = ButtonElement()
      ..className = "icon-toggle-button"
      ..id = "icon-toggle-button-${this._id}"
      ..onClick.listen((_) {
        _inView = !_inView;

        if (_inView) {
          renderElement.classes.toggle("icon-toggle-button--selected", true);
        } else {
          renderElement.classes.toggle("icon-toggle-button--selected", false);
        }

        if (_onToggleController.hasListener) {
          _onToggleController.sink.add(_inView);
        } else {
          logger.warning("No listener for IconButtonView.onToggle");
        }
      });

    renderElement.append(iconElement);

    if (_inView) {
      renderElement.classes.add("icon-toggle-button--selected");
    }
  }
}
