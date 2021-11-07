import 'dart:html';
import 'package:katikati_ui_lib/components/button/button.dart';
import 'package:katikati_ui_lib/components/logger.dart';
import 'package:katikati_ui_lib/components/autocomplete/autocomplete.dart';
import 'package:katikati_ui_lib/components/editable/editable_text.dart';

var logger = Logger('tag.dart');

enum TagStyle {
  None,
  Green,
  Yellow,
  Red,
  Important,
}

/*

<span class="tag tag--suggested tag--editing tag--highlighted tag--pending tag-style--green">
  <span class="tag__text">
    text <span class="fas fa-robot tag--suggested__icon"/>
  </span>
  <span class="tag__actions">
    <button />
  </span>
</span>

*/

class TagView {
  SpanElement renderElement;
  SpanElement _tagText;
  SpanElement _tagActions;

  String _text;
  String _tagId;
  String _category;

  bool _selectable;
  bool _editable;
  bool _deletable;
  bool _acceptable;
  bool _suggested;

  TagStyle _tagStyle;

  Button _editButton;
  Button _deleteButton;
  Button _confirmButton;
  Button _cancelButton;
  Button _acceptButton;

  // some default callbacks, so we can use some behaviours like reset without implementing the raw onclicks
  void Function(String) onEdit = (_) {};
  void Function() onDelete = () {};
  void Function() onSelect = () {};
  void Function() onAccept = () {};
  void Function() onCancel = () {};
  void Function() onMouseEnter = () {};
  void Function() onMouseLeave = () {};

  TagView(this._text, this._tagId,
      {String groupId,
      String category,
      bool selectable = true,
      bool editable = false,
      bool deletable = false,
      bool acceptable = false,
      bool suggested = false,
      TagStyle tagStyle = TagStyle.None,
      bool doubleClickToEdit = true,
      bool actionsBeforeText = false}) {
    _category = category;
    _selectable = selectable;
    _editable = editable;
    _deletable = deletable;
    _acceptable = acceptable;
    _suggested = suggested;

    renderElement = SpanElement()
      ..dataset['id'] = _tagId
      ..dataset['group-id'] = groupId ?? ''
      ..classes.add('tag');

    _tagText = SpanElement()
      ..classes.add('tag__text')
      ..dataset['placeholder'] = "untitled tag";
    _tagActions = SpanElement()..classes.add('tag__actions');

    _tagText.innerText = this._text;

    _acceptButton = Button(ButtonType.confirm, onClick: (e) {
      e.stopPropagation();
      _acceptTag();
    });
    _editButton = Button(ButtonType.edit, onClick: (e) {
      e.stopPropagation();
      beginEdit();
    });
    _confirmButton = Button(ButtonType.confirm, onClick: (e) {
      e.stopPropagation();
      _confirmEdit();
    });
    _cancelButton = Button(ButtonType.cancel, onClick: (e) {
      e.stopPropagation();
      _cancelEditing();
    });
    _deleteButton = Button(ButtonType.remove, onClick: (e) {
      e.stopPropagation();
      _deleteTag();
    });

    if (suggested) {
      var suggestedIcon = SpanElement()..className = 'fas fa-robot tag--suggested__icon';
      _tagText.append(suggestedIcon);
      renderElement.classes.toggle('tag--suggested', true);
    }

    if (_selectable) {
      renderElement.classes.add('tag--selectable');
      _tagText.onClick.listen((e) {
        e.stopPropagation();
        onSelect();
      });
      _tagText.onMouseEnter.listen((_) => onMouseEnter());
      _tagText.onMouseLeave.listen((_) => onMouseLeave());
    }

    if (_acceptable) {
      _tagActions.append(_acceptButton.renderElement);
    }

    if (_editable) {
      _tagActions.append(_editButton.renderElement);

      if (doubleClickToEdit) {
        _tagText.onDoubleClick.listen((_) => beginEdit());
      }
    }

    if (_deletable) {
      _tagActions.append(_deleteButton.renderElement);
    }

    if (actionsBeforeText) {
      renderElement..append(_tagActions)..append(_tagText);
    } else {
      renderElement..append(_tagText)..append(_tagActions);
    }

    setTagStyle(tagStyle);
  }

  void beginEdit() {
    _tagText
      ..contentEditable = "true"
      ..onKeyDown.listen((event) {
        if (event.keyCode == KeyCode.ENTER || event.keyCode == KeyCode.ESC) event.preventDefault();
      })
      ..onKeyUp.listen((event) {
        if (event.keyCode == KeyCode.ENTER) {
          event.preventDefault();
          _confirmEdit();
        }
        if (event.keyCode == KeyCode.ESC) {
          event.preventDefault();
          _cancelEditing();
        }
      });
    renderElement.classes.toggle("tag--editing", true);

    _tagActions.children.clear();
    _tagActions..append(_confirmButton.renderElement)..append(_cancelButton.renderElement);
    focus();
  }

  void focus() {
    _tagText.focus();
  }

  void _cancelEditing() {
    _resetActions();
    _tagText.innerText = _text;
    onCancel();
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

  void markSelected(bool selected) {
    renderElement.classes.toggle("tag--selected", selected);
  }

  void _resetActions() {
    renderElement.classes.toggle("tag--editing", false);
    _tagText..contentEditable = "false";
    _tagActions.children.clear();
    if (_editable) {
      _tagActions.append(_editButton.renderElement);
    }
    if (_acceptable) {
      _tagActions.append(_acceptButton.renderElement);
    }
    if (_deletable) {
      _tagActions.append(_deleteButton.renderElement);
    }
  }

  void markPending(bool pending) {
    renderElement.classes.toggle("tag--pending", pending);
  }

  void markHighlighted(bool highlighted) {
    renderElement.classes.toggle("tag--highlighted", highlighted);
  }

  void setTagStyle(TagStyle tagStyle) {
    _tagStyle = tagStyle;
    renderElement.classes.removeWhere((className) => className.startsWith('tag-style'));
    switch (_tagStyle) {
      case TagStyle.Green:
        renderElement.classes.add("tag-style--green");
        break;
      case TagStyle.Yellow:
        renderElement.classes.add("tag-style--yellow");
        break;
      case TagStyle.Red:
        renderElement.classes.add("tag-style--red");
        break;
      case TagStyle.Important:
        renderElement.classes.add("tag-style--important");
        break;
      default:
    }
  }
}

class TagSuggestion {
  String id;
  String text;

  TagSuggestion(this.id, this.text);
}

class NewTagViewWithSuggestions {
  SpanElement renderElement;
  TextEdit _tagText;

  String _text;
  List<TagSuggestion> _tagSuggestions;

  void Function(String) onNewTag = (_) {};
  void Function(String) onAcceptSuggestion = (_) {};
  void Function() onCancel = () {};

  NewTagViewWithSuggestions(this._tagSuggestions) {
    renderElement = SpanElement()
      ..classes.add("tag")
      ..classes.add("tag--editing")
      ..dataset['id'] = "__new_tag";

    var autocompleteWrapper = DivElement()..className = "tag__suggestions";

    var suggestionsList = _tagSuggestions.map((suggestion) {
      return SuggestionItem(suggestion.id, suggestion.text, DivElement()..innerText = suggestion.text);
    }).toList();

    var emptySuggestionsPlaceholder = DivElement()
      ..classes.add("autocomplete__suggestion-item")
      ..classes.toggle("autocomplete__suggestion-item--disabled")
      ..innerText = "No suggestions";
    var autocompleteList = AutocompleteList(suggestionsList, "", emptyPlaceholder: emptySuggestionsPlaceholder)
      ..onSelect = (suggestionItem) {
        onAcceptSuggestion(suggestionItem.value);
      }
      ..onRequestClose = () {
        autocompleteWrapper.children.clear();
      };

    _tagText = TextEdit("", placeholder: "tag", classname: 'tag__text')
      ..onChange = (value) {
        _text = value;
        autocompleteList.inputText = value;
      }
      ..onEdit = (_) {
        _confirmEdit();
      }
      ..onCancel = () {
        _cancelEditing();
      }
      ..onFocus = () {
        autocompleteWrapper.append(autocompleteList.renderElement);
        autocompleteList.activate();
      }
      ..onBlur = () {
        autocompleteList.deactivate();
      };

    renderElement.onBlur.listen((_) {
      autocompleteList.onRequestClose();
      autocompleteList.deactivate();
    });

    autocompleteList
      ..onFocus = () {
        _tagText.keyboardShortcutEnabled = false;
      }
      ..onBlur = () {
        _tagText.keyboardShortcutEnabled = true;
      };

    renderElement..append(_tagText.renderElement)..append(autocompleteWrapper);
  }

  void focus() {
    _tagText.beginEdit();
  }

  void _cancelEditing() {
    onCancel();
  }

  void _confirmEdit() {
    onNewTag(_text);
  }
}
