import 'dart:html';
import 'dart:async';
import 'package:katikati_ui_lib/components/logger.dart';

var logger = Logger('SidebarIconsView');

class IconButtonView {
  String _id;
  String _favIconClassname;
  bool _inView;

  ButtonElement renderElement;

  Stream<bool> _onToggle;
  StreamController<bool> _onToggleController;
  Stream<bool> get onToggle => _onToggle;

  IconButtonView(this._id, this._favIconClassname, this._inView) {
    this._onToggleController = StreamController();
    this._onToggle = _onToggleController.stream;

    var iconElement = Element.html("<i class='fas fa-${_favIconClassname} icon-toggle'></i>");

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
