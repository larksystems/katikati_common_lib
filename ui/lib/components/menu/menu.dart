import 'dart:html';

import 'package:katikati_ui_lib/components/tooltip/tooltip.dart';

class MenuActionItem {
  DivElement renderElement;
  Function onClick;

  MenuActionItem(this.renderElement, this.onClick) {
    renderElement.onClick.listen((e) {
      e.stopPropagation();
      onClick();
    });
  }
}

/*
<span class="menu-wrapper">
  <span class="menu-icon">
    <icon />
  </span>
  <div class="menu-items-wrapper">
    <div class="menu-item">Item 1</div>
    <div class="menu-item">Item 2</div>
  </div>
</span>
*/

class Menu {
  SpanElement renderElement;
  SpanElement _menuIconWrapper;
  SpanElement _menuItemsWrapper;
  List<MenuActionItem> _actionItems;
  TooltipPosition _menuPosition;

  Menu(this._actionItems, {TooltipPosition menuPosition = TooltipPosition.right}) {
    _menuPosition = menuPosition;
    this._actionItems = this._actionItems ?? [];
    renderElement = SpanElement()..className = "menu-wrapper";

    _menuIconWrapper = SpanElement()..classes.add("menu-icon-wrapper");
    var _menuIcon = SpanElement()..className = "fas fa-ellipsis-v";
    _menuIconWrapper.append(_menuIcon);

    _menuItemsWrapper = SpanElement()
      ..classes.add("menu-items-wrapper")
      ..classes.add(menuPosition.toString().split(".")[1]);
    for (var item in _actionItems) {
      var menuItem = DivElement()
        ..classes.add("menu-item")
        ..append(item.renderElement);
      _menuItemsWrapper.append(menuItem);
    }

    renderElement..append(_menuIconWrapper)..append(_menuItemsWrapper);
  }
}
