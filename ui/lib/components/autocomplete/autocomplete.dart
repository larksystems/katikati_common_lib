import 'dart:html';

class SuggestionItem {
  String _value;
  String _searchString;
  HtmlElement _display;

  String get value => _value;
  String get searchString => _searchString;

  SuggestionItem(this._value, this._searchString, this._display);
}

class AutocompleteList {
  DivElement renderElement;
  DivElement _suggestionsList;
  DivElement _emptyPlaceholder;

  int _listFocusIndex;

  List<SuggestionItem> _allSuggestions;
  List<SuggestionItem> get activeSuggestions {
    if (_inputText == "") return _allSuggestions;
    return _allSuggestions.where((suggestionItem) {
      return suggestionItem.searchString.toLowerCase().contains(_inputText.toLowerCase());
    }).toList();
  }

  String _inputText = "";
  void set inputText(String input) {
    _inputText = input;
    if (_inputText == "") {
      _listFocusIndex = null;
    } else if (_listFocusIndex != null) {
      _listFocusIndex = 0;
    }
    _updateSuggestionListRender();
  }

  void Function(SuggestionItem) onSelect = (_) {};
  void Function() onRequestClose = () {};
  void Function() onFocus = () {};
  void Function() onBlur = () {};

  AutocompleteList(this._allSuggestions, this._inputText, {DivElement emptyPlaceholder}) {
    _emptyPlaceholder = emptyPlaceholder ?? DivElement();

    renderElement = DivElement()..classes.add("autocomplete__wrapper");
    _suggestionsList = DivElement()..classes.add("autocomplete__suggestions");
    renderElement.append(_suggestionsList);
    _updateSuggestionListRender();

    document.onKeyUp.listen(_handleKeyboardInteraction);
  }

  void _handleKeyboardInteraction(KeyboardEvent event) {
    if (activeSuggestions.isEmpty) return;
    switch (event.key) {
      case "ArrowUp":
        event.preventDefault(); // to prevent page scrolling
        _listFocusIndex = _listFocusIndex == null ? activeSuggestions.length - 1 : _listFocusIndex - 1;
        break;
      case "ArrowDown":
        event.preventDefault(); // to prevent page scrolling
        _listFocusIndex = _listFocusIndex == null ? 0 : _listFocusIndex + 1;
        break;
      case "Escape":
        _listFocusIndex = null;
        onRequestClose();
        break;
      case "Enter":
        if (_listFocusIndex != null && _listFocusIndex >= 0 && _listFocusIndex < activeSuggestions.length) {
          _onChoose(activeSuggestions[_listFocusIndex]);
        }
        break;
      default:
        return;
    }
    if (_listFocusIndex != null) {
      if (_listFocusIndex < 0) {
        _listFocusIndex = activeSuggestions.length - 1;
      } else if (_listFocusIndex == activeSuggestions.length) {
        _listFocusIndex = 0;
      }
    } else {
      onBlur();
    }
    _updateSuggestionListRender();
  }

  void _updateSuggestionListRender() {
    _suggestionsList.children.clear();
    var count = 0;
    for (var suggestion in activeSuggestions) {
      var suggestionItem = DivElement()
        ..classes.add("autocomplete__suggestion-item")
        ..classes.toggle("autocomplete__suggestion-item--focussed", count == _listFocusIndex)
        ..dataset['value'] = suggestion._value
        ..dataset['search'] = suggestion._searchString
        ..tabIndex = count
        ..append(suggestion._display)
        ..onClick.listen((_) {
          _onChoose(suggestion);
        });
      if (count == _listFocusIndex) {
        suggestionItem.focus();
        onFocus();
      }
      _suggestionsList.append(suggestionItem);
      count += 1;
    }

    if (activeSuggestions.length == 0) {
      _suggestionsList.append(_emptyPlaceholder);
    }
  }

  void _onChoose(SuggestionItem suggestionItem) {
    _listFocusIndex = null;
    onSelect(suggestionItem);
    onRequestClose();
  }
}
