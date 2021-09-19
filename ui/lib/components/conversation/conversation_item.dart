import 'dart:html';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:katikati_ui_lib/utils/dateTime.dart';
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
  DivElement _dateSeparator;
  CheckboxInputElement _checkboxElement;
  DivElement _messageTextElement;
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

  ConversationItemView(this._id, this._message, this._dateTime, this._status, this._readStatus,
      {bool defaultSelected = false,
      bool defaultChecked = false,
      Set<ConversationWarning> warnings,
      bool checkEnabled = false}) {
    _selected = defaultSelected;
    _checked = defaultChecked;
    _warnings = warnings ?? {};
    _checkEnabled = checkEnabled;

    renderElement = DivElement();

    _dateSeparator = DivElement()
      ..className = "conversation-list__date-separator"
      ..text = dateStringForSeparator(_dateTime)
      ..hidden = true;
    renderElement.append(_dateSeparator);

    _conversationWrapper = DivElement()
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

    var contentWrapper = DivElement()..className = "conversation-item__content";

    var headerElement = DivElement()..className = "conversation-item__header";
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
      ..text = _dateTime == null ? '' : dateFormatter.format(_dateTime);
    headerElement.append(_dateTimeElement);

    var messageElement = DivElement()..className = "conversation-item__message";
    _messageTextElement = DivElement()
      ..className = "conversation-item__message__text"
      ..innerText = _message;
    _messageStatusElement = DivElement()..className = "conversation-item__status";
    _updateStatus(_status);

    messageElement..append(_messageTextElement)..append(_messageStatusElement);
    contentWrapper..append(headerElement)..append(messageElement);
    _conversationWrapper..append(_checkboxWrapper)..append(contentWrapper);

    if (!_checkEnabled) {
      _checkboxWrapper.classes.toggle("hidden", true);
      contentWrapper.classes.toggle("full-width", true);
    }

    this._onSelectController = StreamController();
    this._onSelect = _onSelectController.stream;
    this._onCheckController = StreamController();
    this._onCheck = _onCheckController.stream;
    this._onUncheckController = StreamController();
    this._onUncheck = _onUncheckController.stream;
  }

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

  void enableCheckbox() {
    _checkEnabled = true;
    _checkboxWrapper.classes.toggle("hidden", false);
  }

  void disableCheckbox() {
    _checkEnabled = false;
    _checkboxWrapper.classes.toggle("hidden", true);
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
    _messageTextElement.innerText = text;
  }

  void updateDateTime(DateTime dateTime) {
    _dateTime = dateTime;
    _dateTimeElement.innerText = _dateTime == null ? '' : dateFormatter.format(_dateTime);
    _dateSeparator.innerText = dateStringForSeparator(dateTime);
  }
}
