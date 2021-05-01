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

        renderElement.classes.toggle("icon-toggle-button--selected", _inView);

        if (_onToggleController.hasListener) {
          _onToggleController.sink.add(_inView);
        } else {
          logger.warning("No listener for IconButtonView.onToggle");
        }
      });

    renderElement.append(iconElement);

    renderElement.classes.toggle("icon-toggle-button--selected", _inView);
  }
}