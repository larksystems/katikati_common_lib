import 'dart:html';

import 'package:katikati_ui_lib/components/button/button.dart';

class InlineOverlayModal {
  DivElement inlineOverlayModal;

  InlineOverlayModal(String message, List<Button> buttons) {
    inlineOverlayModal = new DivElement()..classes.add('inline-overlay-modal');

    inlineOverlayModal.append(new ParagraphElement()
      ..classes.add('inline-overlay-modal__message')
      ..text = message);

    var actions = new DivElement()..classes.add('inline-overlay-modal__actions');
    inlineOverlayModal.append(actions);
    for (var button in buttons) {
      button.parent = actions;
    }
  }

  void set parent(Element value) => value.append(inlineOverlayModal);
  void remove() => inlineOverlayModal.remove();
}

class PopupModal {
  DivElement popupModal;

  PopupModal(String message, List<Button> buttons) {
    popupModal = new DivElement()..classes.add('popup-modal');

    popupModal.append(new ParagraphElement()
      ..classes.add('popup-modal__message')
      ..text = message);

    var actions = new DivElement()..classes.add('popup-modal__actions');
    popupModal.append(actions);
    for (var button in buttons) {
      button.parent = actions;
    }
  }

  void set parent(Element value) => value.append(popupModal);
  void remove() => popupModal.remove();
}
