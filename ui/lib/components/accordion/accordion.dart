import 'dart:html';
import 'package:katikati_ui_lib/components/button/button.dart';

/*
<div class="accordion">
  <div class="accordion-item">
    <div class="accordion-item__header">
      <span class="accordion-item__indicator">
        <icon />
      </span>
      <span class="accordion-item__title">
      </span>
    </div>
    <div class="accordion-body__wrapper">
      <body />
    </div>
  </div>
  ...
</div>
*/

const EXPAND_CSS_CLASSNAME = "fas fa-caret-right";
const COLLAPSE_CSS_CLASSSNAME = "fas fa-caret-down";

class AccordionItem {
  String _id;
  bool _isOpen = false;
  SpanElement _indicatorIcon;
  DivElement headerElement;
  DivElement bodyElement;
  DivElement renderElement;

  DivElement _headerWrapper;
  DivElement _bodyWrapper;

  bool get isOpen => _isOpen;
  String get id => _id;

  void set id(String value) {
    _id = value;
    renderElement.dataset['id'] = 'accordion-item-${_id ?? ""}';
  }

  void Function() onToggle = () {};

  AccordionItem(this._id, this.headerElement, this.bodyElement, this._isOpen, {String dataId}) {
    _headerWrapper = DivElement()..className = 'accordion-item__header';
    _indicatorIcon = SpanElement()..className = _isOpen ? COLLAPSE_CSS_CLASSSNAME : EXPAND_CSS_CLASSNAME;
    var indicatorElement = SpanElement()
      ..className = 'accordion-item__indicator'
      ..append(_indicatorIcon);
    var titleElement = SpanElement()
      ..className = 'accordion-item__title'
      ..append(headerElement);
    _headerWrapper
      ..append(indicatorElement)
      ..append(titleElement)
      ..onClick.listen((e) {
        e.stopPropagation();
        toggle();
      });

    _bodyWrapper = DivElement()
      ..className = 'accordion-body__wrapper'
      ..append(bodyElement);
    if (!_isOpen) {
      _bodyWrapper.classes.toggle("hidden", true);
    }

    renderElement = DivElement()
      ..dataset['id'] = 'accordion-item-${_id ?? ""}'
      ..className = 'accordion-item'
      ..append(_headerWrapper)
      ..append(_bodyWrapper);
  }

  void expand() {
    _indicatorIcon.className = COLLAPSE_CSS_CLASSSNAME;
    _bodyWrapper.classes.toggle('hidden', false);
    _isOpen = true;
  }

  void collapse() {
    _indicatorIcon.className = EXPAND_CSS_CLASSNAME;
    _bodyWrapper.classes.toggle("hidden", true);
    _isOpen = false;
  }

  void toggle() {
    _isOpen ? collapse() : expand();
    onToggle();
  }
}

class Accordion {
  List<AccordionItem> _accordionItems;
  bool _onlyOneOpen;
  DivElement _actionWrapper;
  DivElement renderElement;

  List<AccordionItem> get items => _accordionItems;

  Accordion(this._accordionItems, {collapseAtStart: true, expandAtStart: false, onlyOneOpen: false}) {
    _onlyOneOpen = onlyOneOpen;
    var expandButton = Button(ButtonType.expand, hoverText: "Expand all", onClick: (_) => expandAllItems());
    var collapseButton = Button(ButtonType.collapse, hoverText: "Collapse all", onClick: (_) => collapseAllItems());

    _actionWrapper = DivElement()
      ..classes.add('accordion-actions')
      ..append(expandButton.renderElement)
      ..append(collapseButton.renderElement);
    renderElement = DivElement()..className = "accordion";
    renderElement.append(_actionWrapper);
    for (var item in _accordionItems) {
      renderElement.append(item.renderElement);
      if (collapseAtStart) {
        item.collapse();
      }
      if (expandAtStart) {
        item.expand();
      }
    }
  }

  AccordionItem queryItem(String id) {
    return _accordionItems.firstWhere((item) => item._id == id, orElse: () => null);
  }

  void appendItem(AccordionItem item) {
    _accordionItems.add(item);
    renderElement.append(item.renderElement);
  }

  void insertItem(AccordionItem item, int index) {
    _accordionItems.insert(index, item);
    renderElement.insertBefore(item.renderElement, renderElement.children[index]);
  }

  void removeItem(String id) {
    _accordionItems.removeWhere((item) => item._id == id);
    renderElement.children.removeWhere((item) => item.dataset['id'] == 'accordion-item-${id}');
  }

  void updateItem(String id, AccordionItem item) {
    var index = _accordionItems.indexWhere((accordionItem) => accordionItem.id == id);
    if (_accordionItems[index].isOpen) {
      item.expand();
    }
    
    _accordionItems[index] = item;    
    var childIndex = renderElement.children.indexWhere((item) => item.dataset['id'] == 'accordion-item-${id}');
    renderElement.children[childIndex] = item.renderElement;
  }

  void collapseAllItems() {
    for (var item in _accordionItems) {
      item.collapse();
    }
  }

  void expandAllItems() {
    for (var item in _accordionItems) {
      item.expand();
    }
  }

  void collapseItem(String id) {
    for (var item in _accordionItems) {
      if (item._id == id) {
        item.collapse();
      }
    }
  }

  void expandItem(String id) {
    for (var item in _accordionItems) {
      if (item._id == id) {
        item.expand();
      } else if (_onlyOneOpen) {
        item.collapse();
      }
    }
  }

  void clear() {
    _accordionItems = [];
    renderElement.children.clear();
  }
}
