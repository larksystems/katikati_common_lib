import 'dart:html';
import 'package:katikati_ui_lib/components/tooltip/tooltip.dart';

typedef void OnEventCallback(Event e);

class ButtonType {
  final String className;
  final String iconClassName;

  const ButtonType(this.className, {this.iconClassName});

  static const text = ButtonType("button--text");
  static const outlined = ButtonType("button--outlined");
  static const contained = ButtonType("button--contained");
  static const add = ButtonType("button--icon", iconClassName: "fas fa-plus");
  static const remove = ButtonType("button--icon", iconClassName: "far fa-trash-alt");
  static const edit = ButtonType("button--icon", iconClassName: "fas fa-pen");
  static const confirm = ButtonType("button--icon", iconClassName: "fas fa-check");
  static const cancel = ButtonType("button--icon", iconClassName: "fas fa-times");
  static const expand = ButtonType("button--icon", iconClassName: "far fa-plus-square");
  static const collapse = ButtonType("button--icon", iconClassName: "far fa-minus-square");
  static const reset = ButtonType("button--icon", iconClassName: "fas fa-undo");
}

class ButtonAction {
  String buttonText;
  OnEventCallback onClick;

  ButtonAction(this.buttonText, this.onClick);
}

class Button {
  SpanElement _renderElement;
  Tooltip _tooltip;
  ButtonElement _element;

  Button(ButtonType buttonType, {String buttonText = '', String hoverText = '', OnEventCallback onClick}) {
    _renderElement = SpanElement()..className = "button-wrapper";
    _element = new ButtonElement()
      ..classes.add('button')
      ..classes.add(buttonType.className)
      ..title = hoverText
      ..text = buttonText;

    _renderElement.append(_element);

    if (buttonType.iconClassName != null) {
      var icon = SpanElement()..className = buttonType.iconClassName;
      _element.append(icon);
    }

    if (hoverText.isNotEmpty) {
      _tooltip = Tooltip(_element, hoverText);
      _renderElement.append(_tooltip.renderElement);
    }

    onClick = onClick ?? (_) {};
    _element.onClick.listen(onClick);
  }

  Element get renderElement => _renderElement;

  void set visible(bool value) {
    _renderElement.classes.toggle('hidden', !value);
  }

  void set parent(Element value) => value.append(_renderElement);
  void remove() => _renderElement.remove();

  void hide() => _renderElement.setAttribute('hidden', 'true');
  void show() => _renderElement.removeAttribute('hidden');
}
