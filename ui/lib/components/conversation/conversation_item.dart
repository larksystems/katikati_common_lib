import 'dart:html';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:katikati_ui_lib/utils/datetime.dart';
import 'package:katikati_ui_lib/components/tooltip/tooltip.dart';
import 'package:katikati_ui_lib/components/logger.dart';

var logger = Logger('ConversationItemView');

enum ConversationItemStatus { normal, failed, pending, draft }
enum ConversationReadStatus { read, unread }
enum ConversationWarning { notInFilterResults }

final DateFormat dateFormatter = DateFormat("d MMM,").add_jm();

class ConversationItemView {
  DivElement renderElement;

  ConversationItemStatus _status;
  ConversationReadStatus _readStatus;
  Set<ConversationWarning> _warnings;
  String _id;
  String _message;
  DateTime _dateTime;
  bool _selected;
  bool _checked;
  bool _checkEnabled;


  DivElement _conversationWrapper;
  DivElement _contentWrapper;
  DivElement _dateSeparator;
  CheckboxInputElement _checkboxElement;
  DivElement _messageTextElement;
  ImageElement _messageImageElement;
  DivElement _messageStatusElement;
  SpanElement _dateTimeElement;
  DivElement _checkboxWrapper;
  SpanElement _warningWrapper;

  Stream<String> _onSelect;
  StreamController<String> _onSelectController;
  Stream<String> get onSelect => _onSelect;

  Stream<String> _onCheck;
  StreamController<String> _onCheckController;
  Stream<String> get onCheck => _onCheck;

  Stream<String> _onUncheck;
  StreamController<String> _onUncheckController;
  Stream<String> get onUncheck => _onUncheck;

  ConversationItemView(String conversationId, this._id, this._message, this._status, this._readStatus,
      {DateTime dateTime,
      bool defaultSelected = false,
      bool defaultChecked = false,
      Set<ConversationWarning> warnings,
      bool checkEnabled = false}) {
    _selected = defaultSelected;
    _checked = defaultChecked;
    _warnings = warnings ?? {};
    _checkEnabled = checkEnabled;
    _dateTime = dateTime;

    renderElement = DivElement();

    _dateSeparator = DivElement()
      ..className = "conversation-list__date-separator"
      ..text = dateStringForSeparator(_dateTime?.toLocal())
      ..hidden = true;
    renderElement.append(_dateSeparator);

    _conversationWrapper = DivElement()
      ..dataset['conversation-id'] = conversationId
      ..className = "conversation-item"
      ..onClick.listen((event) {
        if (_onSelectController.hasListener) {
          _onSelectController.sink.add(_id);
        } else {
          logger.warning("No listener for ConversationItemView.onSelect");
        }
      });
    if (_selected) {
      _conversationWrapper.classes.add("conversation-item--selected");
    }
    if (_readStatus == ConversationReadStatus.unread) {
      _conversationWrapper.classes.add("conversation-item--unread");
    }
    renderElement.append(_conversationWrapper);

    _checkboxWrapper = DivElement()..className = "conversation-item__checkbox";
    _checkboxElement = CheckboxInputElement()
      ..onClick.listen((e) {
        e.stopPropagation();
      })
      ..onInput.listen((_) {
        var checked = _checkboxElement.checked;
        if (checked) {
          if (_onCheckController.hasListener) {
            _onCheckController.sink.add(_id);
          } else {
            logger.warning("No listener for ConversationItemView.onCheck");
          }
        } else {
          if (_onUncheckController.hasListener) {
            _onUncheckController.sink.add(_id);
          } else {
            logger.warning("No listener for ConversationItemView.onUncheck");
          }
        }
      });
    if (_checked) {
      _checkboxElement.checked = true;
    }
    _checkboxWrapper.append(_checkboxElement);

    _contentWrapper = DivElement()..className = "conversation-item__content";

    var headerElement = DivElement()
      ..dataset['conversation-id'] = conversationId
      ..className = "conversation-item__header";
    _warningWrapper = SpanElement()..className = "conversation-item__warnings";
    var idWrapper = SpanElement()
      ..className = "conversation-item__id"
      ..innerText = _id;
    var warningElements = _createWarningElements(_warnings);
    warningElements.forEach((element) {
      _warningWrapper.append(element);
    });
    headerElement..append(_warningWrapper)..append(idWrapper);

    _dateTimeElement = SpanElement()
      ..className = "conversation-item__date-time"
      ..text = _dateTime == null ? '' : dateFormatter.format(_dateTime.toLocal());
    headerElement.append(_dateTimeElement);

    var messageElement = DivElement()
      ..dataset['conversation-id'] = conversationId
      ..className = "conversation-item__message";
    _messageTextElement = DivElement()
      ..dataset['conversation-id'] = conversationId
      ..className = "conversation-item__message__text";
    _messageImageElement = ImageElement()
      ..style.maxHeight = '25px'
      ..style.verticalAlign = 'middle'
      ..style.padding = '0 8px';
    updateMessage(_message);
    _messageStatusElement = DivElement()..className = "conversation-item__status";
    _updateStatus(_status);

    messageElement..append(_messageTextElement)..append(_messageStatusElement);
    _contentWrapper..append(headerElement)..append(messageElement);
    _conversationWrapper..append(_checkboxWrapper)..append(_contentWrapper);

    enableCheckbox(_checkEnabled);

    this._onSelectController = StreamController();
    this._onSelect = _onSelectController.stream;
    this._onCheckController = StreamController();
    this._onCheck = _onCheckController.stream;
    this._onUncheckController = StreamController();
    this._onUncheck = _onUncheckController.stream;
  }

  DivElement get conversationItem => _conversationWrapper;

  void _updateStatus(ConversationItemStatus status) {
    _messageStatusElement.classes..removeWhere((className) => className.startsWith("converversation-item__status--"));
    _conversationWrapper.classes
      ..removeWhere((classname) =>
          !classname.startsWith("conversation-item--selected") &&
          !classname.startsWith("conversation-item--unread") &&
          classname.startsWith("conversation-item--"));
    switch (status) {
      case ConversationItemStatus.draft:
        _conversationWrapper.classes.add("conversation-item--draft");
        _messageStatusElement
          ..classes.add("converversation-item__status--draft")
          ..innerText = "[draft]";
        break;
      case ConversationItemStatus.failed:
        _conversationWrapper.classes.add("conversation-item--failed");
        _messageStatusElement
          ..classes.add("converversation-item__status--failed")
          ..innerText = "[delivery failure]";
        break;
      case ConversationItemStatus.pending:
        _conversationWrapper.classes.add("conversation-item--pending");
        _messageStatusElement
          ..classes.add("converversation-item__status--pending")
          ..innerText = "[pending]";
        break;
      default:
        _conversationWrapper.classes.add("conversation-item--normal");
        _messageStatusElement
          ..classes.add("converversation-item__status--normal")
          ..innerText = "";
        break;
    }
  }

  List<Element> _createWarningElements(Set<ConversationWarning> warnings) {
    List<Element> warningElements = [];
    for (var warning in warnings) {
      var className = "";
      switch (warning) {
        case ConversationWarning.notInFilterResults:
          className = "filter";
          break;
        default:
          className = "exclamation-triangle";
          break;
      }
      var icon = Element.html('<i class="fa fa-${className} m-r-sm"></i>');
      var iconWithTooltip = Tooltip(icon, "Conversation no longer meets filtering constraints");
      warningElements.add(iconWithTooltip.renderElement);
    }
    return warningElements;
  }

  void check() {
    if (!_checkEnabled) {
      logger.error("Check not allowed");
      return;
    }
    _checked = true;
    _checkboxElement.checked = true;
  }

  void uncheck() {
    if (!_checkEnabled) {
      logger.error("Uncheck not allowed");
      return;
    }
    _checked = false;
    _checkboxElement.checked = false;
  }

  void enableCheckbox(bool enabled) {
    _checkEnabled = enabled;
    _checkboxWrapper.classes.toggle("hidden", !_checkEnabled);
    _contentWrapper.classes.toggle("full-width", !_checkEnabled);
  }

  void select() {
    _selected = true;
    _conversationWrapper.classes.toggle('conversation-item--selected', true);
  }

  void unselect() {
    _selected = false;
    _conversationWrapper.classes.toggle('conversation-item--selected', false);
  }

  void markAsRead() {
    _readStatus = ConversationReadStatus.read;
    _conversationWrapper.classes.toggle('conversation-item--unread', false);
  }

  void markAsUnread() {
    _readStatus = ConversationReadStatus.unread;
    _conversationWrapper.classes.toggle('conversation-item--unread', true);
  }

  void setWarnings(Set<ConversationWarning> warnings) {
    _warnings = warnings;
    _warningWrapper.children.clear();
    var warningElements = _createWarningElements(_warnings);
    warningElements.forEach((element) {
      _warningWrapper.append(element);
    });
  }

  void resetWarnings() {
    _warnings = {};
    _warningWrapper.children.clear();
  }

  void updateStatus(ConversationItemStatus status) {
    _updateStatus(status);
  }

  void toggleDateSeparator(bool show) {
    _dateSeparator.hidden = !show;
  }

  void updateMessage(String text) {
    _message = text;
    _messageTextElement.children.clear();
    if (isImagePath(_message)) {
      _messageImageElement.src = _message;
      _messageTextElement
        ..innerText = 'image'
        ..append(_messageImageElement);
    } else {
      _messageTextElement.innerText = _message;
    }
  }

  void updateDateTime(DateTime dateTime) {
    _dateTime = dateTime;
    _dateTimeElement.innerText = _dateTime == null ? '' : dateFormatter.format(_dateTime.toLocal());
    _dateSeparator.innerText = dateStringForSeparator(dateTime);
  }
}

// TODO(mariana) replace this check with a field on the message
bool isImagePath(String text) {
  var uri = Uri.tryParse(text);
  if (uri == null) return false;
  if (uri.path.endsWith('.jpg') || uri.path.endsWith('.png')) return true;
  return false;
}
