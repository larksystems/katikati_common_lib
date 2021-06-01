import 'dart:html';
import 'package:katikati_ui_lib/components/button/button.dart';
import 'package:katikati_ui_lib/components/logger.dart';

var logger = Logger('tag.dart');

enum TagStyle {
  None,
  Green,
  Yellow,
  Red,
  Important,
}

class TagView {
  SpanElement renderElement;
  SpanElement _tagText;
  SpanElement _tagActions;

  String _text;
  String _tagId;

  bool _selectable;
  bool _editable;
  bool _editableOnAdd;
  bool _removable;
  bool _acceptable;
  bool _suggested;

  TagStyle _tagStyle;

  ButtonElement _editButton;
  ButtonElement _deleteButton;
  ButtonElement _confirmButton;
  ButtonElement _cancelButton;
  ButtonElement _acceptButton;

  // some default callbacks, so we can use some behaviours like reset without implementing the raw onclicks
  void Function(String) onEdit = (_) {};
  void Function() onDelete = () {};
  void Function() onSelect = () {};
  void Function() onAccept = () {};

  TagView(this._text, this._tagId,
      {String groupId,
      bool selectable = true,
      bool editable = false,
      bool editableOnAdd = false,
      bool removable = false,
      bool acceptable = false,
      bool suggested = false,
      TagStyle tagStyle = TagStyle.None,
      bool disableDoubleClickEdit = false}) {
    _selectable = selectable;
    _editable = editable;
    _editableOnAdd = editableOnAdd;
    _removable = removable;
    _acceptable = acceptable;
    _suggested = suggested;

    renderElement = SpanElement()
      ..dataset['id'] = _tagId
      ..dataset['group-id'] = groupId ?? ''
      ..classes.add('tag');

    _tagText = SpanElement()
      ..classes.add('tag-text')
      ..dataset['placeholder'] = "untitled tag";
    _tagActions = SpanElement()..classes.add('tag-actions');

    _tagText.innerText = this._text;
    if (suggested) {
      var suggestedIcon = SpanElement()..className = 'fas fa-robot tag-suggested__icon';
      _tagText.append(suggestedIcon);
      _tagText.classes.toggle('tag-text--suggested', true);
    }

    updateStyle(tagStyle);

    if (_selectable) {
      _tagText.onClick.listen((_) {
        onSelect();
      });
    }

    if (_acceptable) {
      _acceptButton = Button(ButtonType.confirm, onClick: (_) {
        _acceptTag();
      }).renderElement;
      _tagActions.append(_acceptButton);
    }

    if (_editable) {
      _editButton = Button(ButtonType.edit, onClick: (_) {
        _makeEditable();
      }).renderElement;
      _tagActions.append(_editButton);

      _confirmButton = Button(ButtonType.confirm, onClick: (_) {
        _confirmEdit();
      }).renderElement;

      _cancelButton = Button(ButtonType.cancel, onClick: (_) {
        _cancelEditing();
      }).renderElement;

      if (!disableDoubleClickEdit) {
        _tagText.onDoubleClick.listen((_) {
          _makeEditable();
        });
      }
    }

    if (_removable) {
      _deleteButton = Button(ButtonType.remove, onClick: (_) {
        _deleteTag();
      }).renderElement;
      _tagActions.append(_deleteButton);
    }

    if (editable && editableOnAdd) {
      _makeEditable();
    }

    renderElement..append(_tagText)..append(_tagActions);
  }

  void _makeEditable() {
    _tagText
      ..contentEditable = "true"
      ..focus()
      ..onKeyDown.listen((event) {
        if (event.keyCode == KeyCode.ENTER) {
          event.preventDefault();
          _confirmEdit();
        }
        if (event.keyCode == KeyCode.ESC) {
          event.preventDefault();
          _cancelEditing();
        }
      });
    renderElement.classes.toggle("tag-text--editing", true);

    _tagActions.children.clear();
    _tagActions..append(_confirmButton)..append(_cancelButton);
  }

  void _cancelEditing() {
    _resetActions();
    _tagText.innerText = _text;
  }

  void _confirmEdit() {
    _resetActions();
    if (_text != _tagText.innerText) {
      _text = _tagText.innerText;
      onEdit(_text);
    }
  }

  void _deleteTag() {
    _resetActions();
    onDelete();
  }

  void _acceptTag() {
    _resetActions();
    onAccept();
  }

  void _resetActions() {
    renderElement.classes.toggle("tag-text--editing", false);
    _tagText..contentEditable = "false";
    _tagActions.children.clear();
    if (_editable) {
      _tagActions.append(_editButton);
    }
    if (_removable) {
      _tagActions.append(_deleteButton);
    }
    if (_acceptable) {
      _tagActions.append(_acceptButton);
    }
  }

  void markPending(bool pending) {
    renderElement.classes.toggle("tag-text--pending", pending);
  }

  void markHighlighted(bool highlighted) {
    renderElement.classes.toggle("tag-text--highlighted", highlighted);
  }

  void updateStyle(TagStyle tagStyle) {
    _tagStyle = tagStyle;
    _tagText.classes.removeWhere((className) => className.startsWith('tag-text-style'));
    switch (_tagStyle) {
      case TagStyle.Green:
        _tagText.classes.add("tag-text-style--green");
        break;
      case TagStyle.Yellow:
        _tagText.classes.add("tag-text-style--yellow");
        break;
      case TagStyle.Red:
        _tagText.classes.add("tag-text-style--green");
        break;
      case TagStyle.Important:
        _tagText.classes.add("tag-text-style--important");
        break;
      default:
    }
  }
}
