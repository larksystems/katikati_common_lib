import 'dart:html';

import 'package:katikati_ui_lib/components/tooltip/tooltip.dart';

class MenuItem {
  DivElement renderElement;
  Function onClick;

  MenuItem(this.renderElement, this.onClick) {
    renderElement.onClick.listen((e) {
      e.stopPropagation();
      onClick();
    });
  }
}

/*
<span class="menu">
  <span class="menu__icon">
    <icon />
  </span>
  <div class="menu__items">
    <div class="menu__item">Item 1</div>
    <div class="menu__item">Item 2</div>
  </div>
</span>
*/

class Menu {
  SpanElement renderElement;
  SpanElement _menuIconWrapper;
  SpanElement _menuItemsWrapper;
  List<MenuItem> _actionItems;
  TooltipPosition _menuPosition;

  Menu(this._actionItems, {TooltipPosition menuPosition = TooltipPosition.right}) {
    _menuPosition = menuPosition;
    this._actionItems = this._actionItems ?? [];
    renderElement = SpanElement()..className = "menu";

    _menuIconWrapper = SpanElement()..classes.add("menu__icon");
    var _menuIcon = SpanElement()..className = "fas fa-ellipsis-v";
    _menuIconWrapper.append(_menuIcon);

    _menuItemsWrapper = SpanElement()
      ..classes.add("menu__items")
      ..classes.add(_menuPosition.toString().split(".")[1]);
    for (var item in _actionItems) {
      var menuItem = DivElement()
        ..classes.add("menu__item")
        ..append(item.renderElement);
      _menuItemsWrapper.append(menuItem);
    }

    renderElement..append(_menuIconWrapper)..append(_menuItemsWrapper);
  }
}
