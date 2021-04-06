import 'dart:html';
import 'dart:async';

import 'package:katikati_ui_lib/components/button/button.dart';
import 'package:katikati_ui_lib/components/logger.dart';

var logger = Logger('TextEditableView');

class TextEditableView {
  String _text;

  bool _editing = false;

  SpanElement _textSpan;
  Button _editButton;
  Button _removeButton;
  Button _confirmButton;
  Button _discardButton;

  DivElement _renderElement;
  DivElement get renderElement => _renderElement;

  Stream<String> _onChange;
  StreamController<String> _onChangeController;
  Stream<String> get onChange => _onChange;

  Stream<void> _onDelete;
  StreamController<void> _onDeleteController;
  Stream<void> get onDelete => _onDelete;

  TextEditableView(this._text) {
    _renderElement = DivElement()
      ..onMouseEnter.listen((_) {
        if(!_editing) {
          _editButton.show();
          _removeButton.show();
        }
      })
      ..onMouseLeave.listen((_) {
        if(!_editing) {
          _editButton.hide();
          _removeButton.hide();
        }
      });

    _textSpan = SpanElement()
      ..className = "editable-text"
      ..innerText = _text;

    _editButton = Button(ButtonType.edit, onClick: (_) {
      _enableEdit();
    });
    _removeButton = Button(ButtonType.remove, onClick: (_) {
      if (_onChangeController.hasListener) {
        _onDeleteController.sink.add(null);
      } else {
        logger.warning("No listener for TextEditableView.onDelete");
      }
    });
    _confirmButton = Button(ButtonType.confirm, onClick: (_) {
      _confirmEdit();
    });
    _discardButton = Button(ButtonType.remove, onClick: (_) {
      _discardEdit();
    });

    _editButton.hide();
    _removeButton.hide();
    _confirmButton.hide();
    _discardButton.hide();

    _renderElement
      ..append(_textSpan)
      ..append(_editButton.renderElement)
      ..append(_removeButton.renderElement)
      ..append(_confirmButton.renderElement)
      ..append(_discardButton.renderElement);

    this._onChangeController = StreamController();
    this._onChange = _onChangeController.stream;

    this._onDeleteController = StreamController();
    this._onDelete = _onDeleteController.stream;
  }

  void _enableEdit() {
    _editing = true;
    _textSpan.setAttribute('contenteditable', 'true');
    _textSpan.focus();

    _editButton.hide();
    _removeButton.hide();
    _confirmButton.show();
    _discardButton.show();
  }

  void _disableEdit() {
    _editing = false;
    _textSpan.removeAttribute('contenteditable');
    _editButton.renderElement.removeAttribute('hidden');
    _removeButton.renderElement.removeAttribute('hidden');

    _editButton.show();
    _removeButton.show();
    _confirmButton.hide();
    _discardButton.hide();
  }

  void _confirmEdit() {
    _text = _textSpan.innerText;

    if (_onChangeController.hasListener) {
      _onChangeController.sink.add(_textSpan.text);
    } else {
      logger.warning("No listener for TextEditableView.onChange");
    }

    _disableEdit();
  }

  void _discardEdit() {
    _textSpan.innerText = _text;
    _disableEdit();
  }
}
