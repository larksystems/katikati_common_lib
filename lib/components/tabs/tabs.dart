import 'dart:html';
import 'dart:async';
import 'package:katikati_ui_lib/components/logger.dart';

var logger = Logger('Tabs');

class TabView {
  String id;
  String label;
  DivElement content;

  TabView(this.id, this.label, this.content);
}

class TabsView {
  DivElement renderElement;
  List<TabView> _tabs;
  Map<String, TabView> get _tabsById => Map.fromEntries(_tabs.map((t) => MapEntry(t.id, t)));

  String _selectedTabId;
  String _tabContentClassname;

  List<SpanElement> _tabChoosers = [];
  DivElement _tabsHeader;
  DivElement _tabContent;

  TabsView(this._tabs, {String defaultSelectedID, String tabContentClassname}) {
    if (_tabs.isEmpty) {
      throw NullThrownError();
    }

    _selectedTabId = defaultSelectedID ?? _tabs.first.id;
    _tabContentClassname = tabContentClassname;

    _tabsHeader = DivElement();
    _tabs.forEach((tab) {
      var tabChooser = _createTabChooserElement(tab);
      _tabChoosers.add(tabChooser);
      _tabsHeader.append(tabChooser);
    });

    _tabContent = DivElement()
      ..className = "tab-content"
      ..append(_tabsById[_selectedTabId].content);
    if (_tabContentClassname != null) {
      _tabContent.classes.add(_tabContentClassname);
    }

    renderElement = DivElement()..append(_tabsHeader)..append(_tabContent);
  }

  SpanElement _createTabChooserElement(TabView tab) {
    var tabChooser = SpanElement()
      ..innerText = tab.label
      ..className = "tab-chooser"
      ..dataset['id'] = tab.id
      ..onClick.listen((_) {
        _selectTab(tab.id);
      });
    if (tab.id == _selectedTabId) {
      tabChooser.classes.add("tab-chooser--selected");
    }
    return tabChooser;
  }

  void _updateTabContent() {
    _tabContent.children.clear();
    if (_tabsById.containsKey(_selectedTabId)) {
      _tabContent.append(_tabsById[_selectedTabId].content);
    }
  }

  void _selectTab(String id) {
    _selectedTabId = id;
    _tabChoosers.forEach((tabChooser) {
      tabChooser.classes.toggle("tab-chooser--selected", false);
      if (tabChooser.dataset['id'] == id) {
        tabChooser.classes.toggle("tab-chooser--selected");
      }
    });

    _updateTabContent();
  }

  void selectTab(String id) {
    _selectTab(id);
  }

  void removeTab(String id) {
    if (_tabs.isEmpty) {
      throw NullThrownError();
    }

    _tabs.removeWhere((tab) => tab.id == id);
    _tabChoosers.removeWhere((tabChooser) {
      if (tabChooser.dataset['id'] == id) {
        tabChooser.remove();
        return true;
      }
      return false;
    });

    if (_selectedTabId == id) {
      // todo: be a little bit more smart
      _selectTab(_tabs.isNotEmpty ? _tabs.first.id : null);
      _updateTabContent();
    }

    if(_tabs.isEmpty) {
      _tabContent.innerText = "No tabs present";
    }
  }

  void addTab(TabView tab) {
    _tabs.add(tab);
    var tabChooser = _createTabChooserElement(tab);
    _tabChoosers.add(tabChooser);
    _tabsHeader.append(tabChooser);
    _selectTab(tab.id);
  }
}
