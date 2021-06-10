import 'dart:html';

typedef void OnEventCallback(Event e);

enum ButtonType {
  // Text buttons
  text,
  outlined,
  contained,

  // Icon buttons
  add,
  remove,
  confirm,
  cancel,
  edit,
}

class ButtonAction {
  String buttonText;
  OnEventCallback onClick;

  ButtonAction(this.buttonText, this.onClick);
}

class Button {
  ButtonElement _element;

  Button(ButtonType buttonType, {String buttonText = '', String hoverText = '', OnEventCallback onClick}) {
    _element = new ButtonElement()
      ..classes.add('button')
      ..title = hoverText;

    onClick = onClick ?? (_) {};
    _element.onClick.listen(onClick);

    switch (buttonType) {
      case ButtonType.text:
        _element.classes.add('button--text');
        _element.text = buttonText;
        break;
      case ButtonType.outlined:
        _element.classes.add('button--outlined');
        _element.text = buttonText;
        break;
      case ButtonType.contained:
        _element.classes.add('button--contained');
        _element.text = buttonText;
        break;

      case ButtonType.add:
        _element.classes.add('button-text');
        var icon = SpanElement()..className = "fas fa-plus";
        _element.append(icon);
        break;
      case ButtonType.remove:
        _element.classes.add('button--text');
        var icon = SpanElement()..className = "far fa-trash-alt";
        _element.append(icon);
        break;
      case ButtonType.confirm:
        _element.classes.add('button--text');
        var icon = SpanElement()..className = "fas fa-check";
        _element.append(icon);
        break;
      case ButtonType.edit:
        _element.classes.add('button--text');
        var icon = SpanElement()..className = "fas fa-pen";
        _element.append(icon);
        break;
      case ButtonType.cancel:
        _element.classes.add('button--text');
        var icon = SpanElement()..className = "fas fa-times";
        _element.append(icon);
        break;
    }
  }

  Element get renderElement => _element;

  void set visible(bool value) {
    _element.classes.toggle('hidden', !value);
  }

  void set parent(Element value) => value.append(_element);
  void remove() => _element.remove();

  void hide() => _element.setAttribute('hidden', 'true');
  void show() => _element.removeAttribute('hidden');
}
