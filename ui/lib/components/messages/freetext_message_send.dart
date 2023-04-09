import 'dart:html';
import 'dart:async';
import 'dart:math';
import 'package:katikati_ui_lib/components/logger.dart';

var logger = Logger('FreetextMessageSendView');

const MAX_LENGTH = 50000;

class FreetextMessageSendView {
  String _text;
  int _maxLength;
  bool _alwaysShowTextLength;
  TextAreaElement _textArea;
  SpanElement _textLength;
  ButtonElement _sendButton;
  ButtonElement _clearButton;

  DivElement renderElement;

  Stream<String> _onSend;
  StreamController<String> _onSendController;
  Stream<String> get onSend => _onSend;

  FreetextMessageSendView(this._text, {int maxLength = MAX_LENGTH, bool alwaysShowTextLength = false}) {
    _maxLength = min(maxLength, MAX_LENGTH);
    _alwaysShowTextLength = alwaysShowTextLength;

    _onSendController = StreamController();
    _onSend = _onSendController.stream;

    _textArea = TextAreaElement()
      ..defaultValue = _text
      ..placeholder = "Type your message..."
      ..onInput.listen((e) {
        _text = _textArea.value;
        _enableOrDisableButtons();
        _showOrClearMaxLengthError();
      });
    _sendButton = ButtonElement()
      ..innerText = "Send"
      ..onClick.listen((_) {
        if (_onSendController.hasListener) {
          _onSendController.sink.add(_text);
        } else {
          logger.warning("No listener for FreetextMessageSendView.onSend");
        }
      });

    _textLength = SpanElement()
      ..innerText = "${_text.length} / $_maxLength"
      ..className = "message-editor-with-send__text-length"
      ..hidden = !_alwaysShowTextLength;

    var clearIcon = Element.html('<i class="fas fa-times"></i>');
    _clearButton = ButtonElement()
      ..append(clearIcon)
      ..className = "message-editor-with-send__clear-button"
      ..onClick.listen((_) {
        clear();
      });

    var textareaWrapper = DivElement()
      ..className = "message-editor-with-send__message"
      ..append(_textArea)
      ..append(_clearButton)
      ..append(_textLength);
    var sendButtonWrapper = DivElement()
      ..className = "message-editor-with-send__send-button"
      ..append(_sendButton);

    renderElement = DivElement()
      ..className = "message-editor-with-send"
      ..append(textareaWrapper)
      ..append(sendButtonWrapper);
  }

  void _enableOrDisableButtons() {
    if (_text.isEmpty) {
      _sendButton.setAttribute("disabled", "true");
      _clearButton.setAttribute("disabled", "true");
    } else if (_text.length > _maxLength) {
      _sendButton.setAttribute("disabled", "true");
    } else {
      _sendButton.removeAttribute("disabled");
      _clearButton.removeAttribute("disabled");
    }
  }

  void _showOrClearMaxLengthError() {
    _textLength.innerText = "${_text.length} / $_maxLength";
    if (_text.length > _maxLength) {
      renderElement.classes.toggle("message-editor-with-send--error", true);
      _textLength.hidden = false;
    } else {
      renderElement.classes.toggle("message-editor-with-send--error", false);
      if (!_alwaysShowTextLength) {
        _textLength.hidden = true;
      }
    }
  }

  void clear() {
    _text = "";
    _textArea.value = "";
    _enableOrDisableButtons();
    _showOrClearMaxLengthError();
  }

  void set text(String value) {
    _text = value;
    _textArea.value = value;
    _enableOrDisableButtons();
    _showOrClearMaxLengthError();
  }

  void toggleVisibility(bool show) => renderElement.classes.toggle('hidden', !show);
}
