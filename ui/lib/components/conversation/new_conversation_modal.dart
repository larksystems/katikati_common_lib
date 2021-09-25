import 'dart:html';

import 'package:katikati_ui_lib/components/button/button.dart';

class NewConversationFormData {
  String name;
  String phoneNumber;
  List<String> tags;

  NewConversationFormData(this.phoneNumber, this.name, this.tags);
}

class NewConversationModal {
  SpanElement renderElement;
  SpanElement _addButtonElement;
  FormElement _modalWrapper;
  DivElement _backDrop;

  InputElement _phoneNumberElement;
  InputElement _nameElement;
  InputElement _tagsElement;

  Button _submitButton;
  Button _clearButton;

  bool _modalOpen = false;

  Function(List<NewConversationFormData>) onSubmit;

  NewConversationModal() {
    _addButtonElement = SpanElement()
      ..className = "fas fa-plus-square"
      ..onClick.listen((e) {
        e.stopPropagation();
        _toggleModal(!_modalOpen);
      });

    _modalWrapper = FormElement()
      ..hidden = true
      ..className = "new-conversation-modal--wrapper"
      ..onSubmit.listen(_submitForm);

    var phoneNumberLabel = LabelElement()..innerText = "Phone number";
    _phoneNumberElement = InputElement()
      ..type = "tel"
      ..required = true;
    var nameLabel = LabelElement()..innerText = "Name";
    _nameElement = InputElement()
      ..type = "text"
      ..required = true;
    var tagsLabel = LabelElement()..innerText = "Tags";
    _tagsElement = InputElement()
      ..type = "text"
      ..placeholder = "Comma separated e.g. tag1, tag2";

    var actionBar = DivElement()..className = "new-conversation-modal--actions";
    _submitButton = Button(ButtonType.text, buttonText: "Start conversation", onClick: _submitForm);
    (_submitButton.renderElement as ButtonElement).type = "submit";
    actionBar.append(_submitButton.renderElement);

    _clearButton = Button(ButtonType.text, buttonText: "Reset", onClick: _clearForm);
    _clearButton.renderElement.classes.add("reset-button");
    actionBar.append(_clearButton.renderElement);

    _modalWrapper
      ..append(phoneNumberLabel)
      ..append(_phoneNumberElement)
      ..append(nameLabel)
      ..append(_nameElement)
      ..append(tagsLabel)
      ..append(_tagsElement)
      ..append(actionBar);

    _backDrop = DivElement()
      ..className = "new-conversation--backdrop"
      ..hidden = true;

    renderElement = SpanElement()
      ..className = "new-conversation-modal"
      ..append(_addButtonElement)
      ..append(_modalWrapper)
      ..append(_backDrop);

    _backDrop.onClick.listen((e) {
      _toggleModal(false);
    });
  }

  void _submitForm(Event e) {
    String phoneNumber = _phoneNumberElement.value.trim();
    String name = _nameElement.value.trim();
    List<String> tags = _tagsElement.value.trim().split(",").map((value) => value.trim()).toList();

    if (phoneNumber == "" || name == "") {
      return;
    }

    e.preventDefault();
    if (onSubmit != null) {
      var data = NewConversationFormData(phoneNumber, name, tags);
      onSubmit([data]);
    }
  }

  void closeModal({bool preserveInput = false}) {
    if (!preserveInput) {
      _clearForm(null);
    }
    _toggleModal(false);
  }

  void _clearForm(e) {
    if (e != null) {
      e.preventDefault();
    }
    _phoneNumberElement.value = "";
    _nameElement.value = "";
    _tagsElement.value = "";
    _phoneNumberElement.focus();
  }

  void _toggleModal(bool show) {
    _modalOpen = show;
    _modalWrapper.hidden = !_modalOpen;
    if (_modalOpen) {
      _phoneNumberElement.focus();
    }
    _backDrop.hidden = !_modalOpen;
  }
}
