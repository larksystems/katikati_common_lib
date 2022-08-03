import 'dart:html';
import 'package:katikati_ui_lib/components/button/button.dart';
import 'package:dnd/dnd.dart';

/*
<div class="accordion">
  <div class="accordion-item">
    <div class="accordion-item__header">
      <span class="accordion-item__sort-handle">
        <icon />
      </span>
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
const SORTABLE_DATASET_KEY = "sortable";
const ACCORDION_ITEM_HANDLE_CSS_CLASSNAME = "accordion-item__sort-handle";

class AccordionItem {
  String _id;
  bool _isOpen = false;
  SpanElement _indicatorIcon;
  SpanElement _sortIcon;
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

  void set sortableId(String id) {
    renderElement.dataset[SORTABLE_DATASET_KEY] = id;
    _sortIcon.classes.toggle('hidden', id == null);
  }

  void Function() onToggle = () {};

  AccordionItem(this._id, this.headerElement, this.bodyElement, this._isOpen, {String dataId, String sortableId}) {
    _headerWrapper = DivElement()..className = 'accordion-item__header';
    _indicatorIcon = SpanElement()..className = _isOpen ? COLLAPSE_CSS_CLASSSNAME : EXPAND_CSS_CLASSNAME;
    _sortIcon = SpanElement()
      ..className = '$ACCORDION_ITEM_HANDLE_CSS_CLASSNAME fas fa-grip-vertical'
      ..classes.toggle('hidden', sortableId == null);
    var indicatorElement = SpanElement()
      ..className = 'accordion-item__indicator'
      ..append(_indicatorIcon);
    var titleElement = SpanElement()
      ..className = 'accordion-item__title'
      ..append(headerElement);
    _headerWrapper
      ..append(_sortIcon)
      ..append(indicatorElement)
      ..append(titleElement);

    indicatorElement.onClick.listen((e) {
      e.stopPropagation();
      toggle();
    });
    titleElement.onClick.listen((e) {
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
  DivElement _accordionsWrapper;
  DivElement renderElement;
  String _sortableId;
  void Function(String, int) onSort;

  Map<String, Draggable> _draggables = {};
  Map<String, Dropzone> _dropzones = {};

  List<AccordionItem> get items => _accordionItems;

  Accordion(this._accordionItems, {collapseAtStart: true, expandAtStart: false, onlyOneOpen: false, String sortableId}) {
    _accordionItems.forEach((accordionItem) => accordionItem.sortableId = _sortableId);

    _onlyOneOpen = onlyOneOpen;
    var expandButton = Button(ButtonType.expand, hoverText: "Expand all", onClick: (_) => expandAllItems());
    var collapseButton = Button(ButtonType.collapse, hoverText: "Collapse all", onClick: (_) => collapseAllItems());

    renderElement = DivElement()..className = "accordion";

    _actionWrapper = DivElement()
      ..classes.add('accordion-actions')
      ..append(expandButton.renderElement)
      ..append(collapseButton.renderElement);
    renderElement.append(_actionWrapper);

    _accordionsWrapper = DivElement();
    renderElement.append(_accordionsWrapper);

    for (var item in _accordionItems) {
      _accordionsWrapper.append(item.renderElement);
      if (collapseAtStart) {
        item.collapse();
      }
      if (expandAtStart) {
        item.expand();
      }
    }

    _sortableId = sortableId;
    _makeSortable();
  }

  AccordionItem queryItem(String id) {
    return _accordionItems.firstWhere((item) => item._id == id, orElse: () => null);
  }

  void _makeSortable() {
    if (_sortableId == null) return;

    _accordionItems.forEach((accordionItem) => accordionItem.sortableId = _sortableId);

    for (var accordionItem in _accordionItems) {
      _makeDraggable(accordionItem);
      _makeDropzone(accordionItem);
    }
  }

  void _makeDraggable(AccordionItem accordionItem) {
    var _draggable = Draggable(accordionItem.renderElement, avatarHandler: AvatarHandler.clone(), verticalOnly: true, handle: '.$ACCORDION_ITEM_HANDLE_CSS_CLASSNAME');
    _draggable.onDragStart.listen((DraggableEvent event) {
      collapseAllItems();
    });
    _draggables[accordionItem.id] = _draggable;
  }

  void _makeDropzone(AccordionItem accordionItem) {
    var _dropzone = Dropzone(accordionItem.renderElement);
    _dropzone.onDragOver.listen((DropzoneEvent event) {
      event.avatarHandler.avatar?.classes?.toggle('drag-element', true);
    });
    _dropzone.onDragEnter.listen((event) {
      if (!_dragAllowed(event)) return;
      event.dropzoneElement.classes.toggle('drag--over', true);
    });
    _dropzone.onDragLeave.listen((event) {
      if (!_dragAllowed(event)) return;
      event.dropzoneElement.classes.toggle('drag--over', false);
    });
    _dropzone.onDrop.listen((DropzoneEvent event) {
      if (!_dragAllowed(event)) return;

      String moveId;
      int moveToIndex;
      int index = 0;
      _accordionItems.forEach((element) {
        if (event.draggableElement.dataset["id"] == "accordion-item-${element._id}") {
          moveId = element._id;
        }
        if (event.dropzoneElement.dataset["id"] == "accordion-item-${element._id}") {
          moveToIndex = index;
        }
        ++index;
      });

      if (moveId != null && moveToIndex != null) {
        onSort(moveId, moveToIndex);
      }
    });
    _dropzones[accordionItem.id] =_dropzone;
  }

  bool _dragAllowed(DropzoneEvent event) {
    return event.draggableElement.dataset[SORTABLE_DATASET_KEY] == event.dropzoneElement.dataset[SORTABLE_DATASET_KEY];
  }

  void appendItem(AccordionItem item) {
    _accordionItems.add(item);
    _accordionsWrapper.append(item.renderElement);
    item.sortableId = _sortableId;
    _makeDraggable(item);
    _makeDropzone(item);
  }

  void insertItem(AccordionItem item, int index) {
    _accordionItems.insert(index, item);
    _accordionsWrapper.insertBefore(item.renderElement, _accordionsWrapper.children[index]);
    item.sortableId = _sortableId;
    _makeDraggable(item);
    _makeDropzone(item);
  }

  void removeItem(String id) {
    _accordionItems.removeWhere((item) => item._id == id);
    _accordionsWrapper.children.removeWhere((item) => item.dataset['id'] == 'accordion-item-${id}');
    _draggables[id].destroy();
    _dropzones[id].destroy();
  }

  void updateItem(String id, AccordionItem item) {
    var index = _accordionItems.indexWhere((accordionItem) => accordionItem.id == id);
    if (_accordionItems[index].isOpen) {
      item.expand();
    }

    _accordionItems[index] = item;
    var childIndex = _accordionsWrapper.children.indexWhere((item) => item.dataset['id'] == 'accordion-item-${id}');
    _accordionsWrapper.children[childIndex] = item.renderElement;
  }

  void reorderItem(AccordionItem item, int newIndex) {
    _accordionItems.remove(item);
    _accordionItems.insert(newIndex, item);
    item.renderElement.remove();
    _accordionsWrapper.insertBefore(item.renderElement, _accordionsWrapper.children[newIndex]);
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
    _accordionsWrapper.children.clear();
  }
}
