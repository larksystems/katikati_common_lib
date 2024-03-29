import 'dart:html';
import 'package:katikati_ui_lib/components/button/button.dart';
import 'package:katikati_ui_lib/components/logger.dart';
import 'package:katikati_ui_lib/components/autocomplete/autocomplete.dart';
import 'package:katikati_ui_lib/components/editable/editable_text.dart';
import 'package:katikati_ui_lib/components/menu/menu.dart';

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
  SpanElement _tagTextWrapper;
  SpanElement _tagText;
  SpanElement _tagShortcut;
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
  Menu _menu;
  List<MenuItem> _menuItems;

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

  void set text(String text) {
    _text = text;
    _tagText.innerText = text;
  }

  TagView(this._text, this._tagId,
      {String groupId,
      String category,
      String shortcut = "",
      bool selectable = true,
      bool editable = false,
      bool deletable = false,
      bool acceptable = false,
      bool suggested = false,
      TagStyle tagStyle = TagStyle.None,
      bool doubleClickToEdit = true,
      bool actionsBeforeText = false,
      List<MenuItem> menuItems,
      String placeholder}) {
    _category = category;
    _selectable = selectable;
    _editable = editable;
    _deletable = deletable;
    _acceptable = acceptable;
    _suggested = suggested;
    _menuItems = menuItems;

    renderElement = SpanElement()
      ..dataset['id'] = _tagId
      ..dataset['group-id'] = groupId ?? ''
      ..classes.add('tag');

    _tagTextWrapper = SpanElement();
    _tagText = SpanElement()
      ..classes.add('tag__text')
      ..dataset['tag-id'] = _tagId;
    if (placeholder != null) {
      _tagText.dataset['placeholder'] = placeholder;
    }
    _tagShortcut = SpanElement()..classes.add('tag__shortcut');
    _tagTextWrapper.append(_tagText);
    if (shortcut != "") {
      _tagShortcut
        ..title = "Shortcut"
        ..append(SpanElement()..innerText = shortcut);
      _tagTextWrapper.append(_tagShortcut);
    }
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
      _tagTextWrapper.onClick.listen((e) {
        e.stopPropagation();
        onSelect();
      });
      _tagTextWrapper.onMouseEnter.listen((_) => onMouseEnter());
      _tagTextWrapper.onMouseLeave.listen((_) => onMouseLeave());
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
      renderElement..append(_tagActions)..append(_tagTextWrapper);
    } else {
      renderElement..append(_tagTextWrapper)..append(_tagActions);
    }

    setTagStyle(tagStyle);

    if (menuItems != null) {
      _menu = Menu(menuItems);
      _tagActions.append(_menu.renderElement);
    }
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
    _text = _tagText.innerText;
    onEdit(_text);
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

    if (_menuItems != null) {
      _menu = Menu(_menuItems);
      _tagActions.append(_menu.renderElement);
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
  DivElement _boundingElement;

  String _text;
  List<TagSuggestion> _tagSuggestions;
  AutocompleteList _autocompleteList;

  void Function(String) onNewTag = (_) {};
  void Function(String) onAcceptSuggestion = (_) {};
  void Function() onCancel = () {};

  NewTagViewWithSuggestions(this._tagSuggestions, {DivElement boundingElement}) {
    _boundingElement = boundingElement;
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
    _autocompleteList = AutocompleteList(suggestionsList, "",
        emptyPlaceholder: emptySuggestionsPlaceholder, boundingElement: _boundingElement)
      ..onSelect = (suggestionItem) {
        onAcceptSuggestion(suggestionItem.value);
      }
      ..onRequestClose = () {
        autocompleteWrapper.children.clear();
      };

    _tagText = TextEdit("", placeholder: "tag", classname: 'tag__text')
      ..onChange = (value) {
        _text = value;
        _autocompleteList.inputText = value;
      }
      ..onEdit = (_) {
        _confirmEdit();
      }
      ..onCancel = () {
        _cancelEditing();
      }
      ..onFocus = () {
        autocompleteWrapper.append(_autocompleteList.renderElement);
        _autocompleteList.activate();
      }
      ..onBlur = () {
        _autocompleteList.deactivate();
      };

    renderElement.onBlur.listen((_) {
      _autocompleteList.onRequestClose();
      _autocompleteList.deactivate();
    });

    _autocompleteList
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
    _autocompleteList.adjustAutocompletePosition();
  }

  void _cancelEditing() {
    onCancel();
  }

  void _confirmEdit() {
    if (_autocompleteList.activeSuggestions.isNotEmpty && _autocompleteList.activeSuggestions.first.searchString == _text) {
      onAcceptSuggestion(_autocompleteList.activeSuggestions.first.value);
    } else {
      onNewTag(_text);
    }
  }
}
