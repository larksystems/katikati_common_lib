import 'dart:html';
import 'dart:async';
import 'package:katikati_ui_lib/components/logger.dart';

var logger = Logger('ConversationItemView');

enum ConversationItemStatus { normal, failed, pending, draft }

class ConversationItemView {
  DivElement renderElement;

  ConversationItemStatus _status;
  String _id;
  String _message;
  bool _selected;
  bool _checked;

  CheckboxInputElement _checkboxElement;
  SpanElement _messageStatusElement;

  Stream<String> _onSelect;
  StreamController<String> _onSelectController;
  Stream<String> get onSelect => _onSelect;

  Stream<String> _onCheck;
  StreamController<String> _onCheckController;
  Stream<String> get onCheck => _onCheck;

  Stream<String> _onUncheck;
  StreamController<String> _onUncheckController;
  Stream<String> get onUncheck => _onUncheck;

  ConversationItemView(this._id, this._message, this._status,
      {bool defaultSelected = false, bool defaultChecked = false}) {
    _selected = defaultSelected;
    _checked = defaultChecked;

    renderElement = DivElement()..className = "conversation-item";
    if (_selected) {
      renderElement.classes.add("conversation-item--selected");
    }

    var checkboxWrapper = DivElement()..className = "conversation-item__checkbox";
    _checkboxElement = CheckboxInputElement()
      ..onInput.listen((_) {
        var checked = _checkboxElement.checked;
        if (checked) {
          if (_onCheckController.hasListener) {
            _onCheckController.sink.add(_id);
          } else {
            logger.warning("No listener for ConversationItemView.onSelect");
          }
        } else {
          if (_onUncheckController.hasListener) {
            _onUncheckController.sink.add(_id);
          } else {
            logger.warning("No listener for ConversationItemView.onSelect");
          }
        }
      });
    if (_checked) {
      _checkboxElement.checked = true;
    }
    checkboxWrapper.append(_checkboxElement);

    var contentWrapper = DivElement()
      ..className = "conversation-item__content"
      ..onClick.listen((event) {
        if (_onSelectController.hasListener) {
          _onSelectController.sink.add(_id);
        } else {
          logger.warning("No listener for ConversationItemView.onSelect");
        }
      });

    var idElement = DivElement()
      ..className = "conversation-item__id"
      ..innerText = _id;

    var messageElement = DivElement()..className = "conversation-item__message";
    var messageTextElement = SpanElement()
      ..className = "conversation-item__message__text"
      ..innerText = _message;
    _messageStatusElement = SpanElement()..className = "conversation-item__status";
    _updateStatus(_status);

    messageElement..append(messageTextElement)..append(_messageStatusElement);
    contentWrapper..append(idElement)..append(messageElement);
    renderElement..append(checkboxWrapper)..append(contentWrapper);

    this._onSelectController = StreamController();
    this._onSelect = _onSelectController.stream;
    this._onCheckController = StreamController();
    this._onCheck = _onCheckController.stream;
    this._onUncheckController = StreamController();
    this._onUncheck = _onUncheckController.stream;
  }

  void _updateStatus(ConversationItemStatus status) {
    _messageStatusElement.classes..removeWhere((className) => className.startsWith("converversation-item__status--"));
    renderElement.classes
      ..removeWhere((classname) =>
          !classname.startsWith("conversation-item--selected") && classname.startsWith("conversation-item--"));
    switch (status) {
      case ConversationItemStatus.draft:
        renderElement.classes.add("conversation-item--draft");
        _messageStatusElement
          ..classes.add("converversation-item__status--draft")
          ..innerText = "[draft]";
        break;
      case ConversationItemStatus.failed:
        renderElement.classes.add("conversation-item--failed");
        _messageStatusElement
          ..classes.add("converversation-item__status--failed")
          ..innerText = "[delivery failure]";
        break;
      case ConversationItemStatus.pending:
        renderElement.classes.add("conversation-item--pending");
        _messageStatusElement
          ..classes.add("converversation-item__status--pending")
          ..innerText = "[pending]";
        break;
      default:
        renderElement.classes.add("conversation-item--normal");
        _messageStatusElement
          ..classes.add("converversation-item__status--normal")
          ..innerText = "";
        break;
    }
  }

  void check() {
    _checked = true;
    _checkboxElement.checked = true;
  }

  void uncheck() {
    _checked = false;
    _checkboxElement.checked = false;
  }

  void select() {
    _selected = true;
    renderElement.classes.toggle('conversation-item--selected', true);
  }

  void unselect() {
    _selected = false;
    renderElement.classes.toggle('conversation-item--selected', false);
  }

  void updateStatus(ConversationItemStatus status) {
    _updateStatus(status);
  }
}
