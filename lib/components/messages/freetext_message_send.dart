import 'dart:html';
import 'dart:async';
import 'package:katikati_ui_lib/components/logger.dart';

var logger = Logger('FreetextMessageSendView');

class FreetextMessageSendView {
  String _text;
  TextAreaElement _textArea;
  ButtonElement _sendButton;
  ButtonElement _clearButton;

  DivElement renderElement;

  Stream<String> _onSend;
  StreamController<String> _onSendController;
  Stream<String> get onSend => _onSend;

  FreetextMessageSendView(this._text) {
    _onSendController = StreamController();
    _onSend = _onSendController.stream;

    _textArea = TextAreaElement()
      ..defaultValue = _text
      ..placeholder = "Type your message..."
      ..onInput.listen((e) {
        _text = _textArea.value;
        _enableOrDisableButtons();
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
      ..append(_clearButton);
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
    } else {
      _sendButton.removeAttribute("disabled");
      _clearButton.removeAttribute("disabled");
    }
  }

  void clear() {
    _text = "";
    _textArea.value = "";
    _enableOrDisableButtons();
  }
}
