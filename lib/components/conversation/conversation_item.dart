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
  bool _choosen;
  bool _selected;

  CheckboxInputElement _checkboxElement;
  SpanElement _messageStatusElement;

  Stream<String> _onChoose;
  StreamController<String> _onChooseController;
  Stream<String> get onChoose => _onChoose;

  Stream<String> _onSelect;
  StreamController<String> _onSelectController;
  Stream<String> get onSelect => _onSelect;

  Stream<String> _onDeselect;
  StreamController<String> _onDeselectController;
  Stream<String> get onDeselect => _onDeselect;

  ConversationItemView(this._id, this._message, this._status,
      {bool defaultChosen = false, bool defaultSelected = false}) {
    _choosen = defaultChosen;
    _selected = defaultSelected;

    renderElement = DivElement()..className = "conversation-item";
    if (_choosen) {
      renderElement.classes.add("conversation-item--selected");
    }

    var checkboxWrapper = DivElement()..className = "conversation-item-checkbox--wrapper";
    _checkboxElement = CheckboxInputElement()
      ..onInput.listen((event) {
        event.stopPropagation();
        event.preventDefault();
        var checked = (event.currentTarget as CheckboxInputElement).checked;
        if (checked) {
          if (_onSelectController.hasListener) {
            _onSelectController.sink.add(_id);
          } else {
            logger.warning("No listener for ConversationItemView.onSelect");
          }
        } else {
          if (_onDeselectController.hasListener) {
            _onDeselectController.sink.add(_id);
          } else {
            logger.warning("No listener for ConversationItemView.onSelect");
          }
        }
      });
    if (_selected) {
      _checkboxElement.checked = true;
    }
    checkboxWrapper.append(_checkboxElement);

    var contentWrapper = DivElement()
      ..className = "conversation-item-content--wrapper"
      ..onClick.listen((event) {
        if (_onChooseController.hasListener) {
          _onChooseController.sink.add(_id);
        } else {
          logger.warning("No listener for ConversationItemView.onCHoose");
        }
      });

    var idElement = DivElement()
      ..className = "conversation-item-id"
      ..innerText = _id;

    var messageElement = DivElement()..className = "conversation-item-message";
    var messageTextElement = SpanElement()
      ..className = "conversation-item-message-text"
      ..innerText = _message;
    _messageStatusElement = SpanElement()..className = "conversation-item-status";
    _updateStatus(_status);

    messageElement..append(messageTextElement)..append(_messageStatusElement);
    contentWrapper..append(idElement)..append(messageElement);
    renderElement..append(checkboxWrapper)..append(contentWrapper);

    this._onChooseController = StreamController();
    this._onChoose = _onChooseController.stream;
    this._onSelectController = StreamController();
    this._onSelect = _onSelectController.stream;
    this._onDeselectController = StreamController();
    this._onDeselect = _onDeselectController.stream;
  }

  void _updateStatus(ConversationItemStatus status) {
    var messageStatusClasses = _messageStatusElement.classes
      ..removeWhere((classname) {
        return classname.indexOf("converversation-item-status--") == 0;
      });
    var renderElementClasses = renderElement.classes
      ..removeWhere((classname) {
        return classname.indexOf("conversation-item--selected") != 0 && classname.indexOf("conversation-item--") == 0;
      });
    switch (status) {
      case ConversationItemStatus.draft:
        renderElementClasses.add("conversation-item--draft");
        renderElement.className = renderElementClasses.join(" ");
        messageStatusClasses.add("converversation-item-status--draft");
        _messageStatusElement
          ..innerText = "[draft]"
          ..className = messageStatusClasses.join(" ");
        break;
      case ConversationItemStatus.failed:
        renderElementClasses.add("conversation-item--failed");
        renderElement.className = renderElementClasses.join(" ");
        messageStatusClasses.add("converversation-item-status--failed");
        _messageStatusElement
          ..innerText = "[delivery failure]"
          ..className = messageStatusClasses.join(" ");
        break;
      case ConversationItemStatus.pending:
        renderElementClasses.add("conversation-item--pending");
        renderElement.className = renderElementClasses.join(" ");
        messageStatusClasses.add("converversation-item-status--pending");
        _messageStatusElement
          ..innerText = "[pending]"
          ..className = messageStatusClasses.join(" ");
        break;
      default:
        renderElementClasses.add("conversation-item--normal");
        renderElement.className = renderElementClasses.join(" ");
        messageStatusClasses.add("converversation-item-status--normal");
        _messageStatusElement
          ..innerText = ""
          ..className = messageStatusClasses.join(" ");
    }
  }

  void select() {
    _selected = true;
    _checkboxElement.checked = true;
  }

  void unSelect() {
    _selected = false;
    _checkboxElement.checked = false;
  }

  void choose() {
    _choosen = true;
    renderElement.classes.toggle('conversation-item--selected', true);
  }

  void unChoose() {
    _choosen = false;
    renderElement.classes.toggle('conversation-item--selected', false);
  }

  void updateStatus(ConversationItemStatus status) {
    _updateStatus(status);
  }
}
