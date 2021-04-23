import 'dart:html';
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

  String _selectedTabID;
  String _tabContentClassname;

  List<SpanElement> _tabChoosers = [];
  DivElement _tabContent;

  TabsView(this._tabs, {String defaultSelectedID, String tabContentClassname}) {
    if (defaultSelectedID != null) {
      _selectedTabID = defaultSelectedID;
    } else {
      _selectedTabID = _tabs.first.id;
    }

    var selectedIndex = _getSelectedIndex(_selectedTabID);

    _tabContentClassname = tabContentClassname;

    var tabsHeader = DivElement();
    _tabs.asMap().forEach((index, tab) {
      var tabChooser = SpanElement()
        ..innerText = tab.label
        ..className = "tab-chooser"
        ..id = "tab-chooser-${tab.id}"
        ..onClick.listen((_) {
          _selectTab(tab.id);
        });
      if (tab.id == _selectedTabID) {
        tabChooser.classes.add("tab-chooser--selected");
      }
      _tabChoosers.add(tabChooser);
      tabsHeader.append(tabChooser);
    });

    _tabContent = DivElement()
      ..className = "tab-content"
      ..append(_tabs[selectedIndex].content);
    if (_tabContentClassname != null) {
      _tabContent.classes.add(_tabContentClassname);
    }

    renderElement = DivElement()..append(tabsHeader)..append(_tabContent);
  }

  int _getSelectedIndex(String id) {
    var index = _tabs.indexWhere((tab) => tab.id == id);
    if (index < 0) {
      throw IndexError(index, "Tab ID $id not found");
    }
    return index;
  }

  void _selectTab(String id) {
    var oldSelectedIndex = _getSelectedIndex(_selectedTabID);
    var newSelectedIndex = _getSelectedIndex(id);

    _tabContent.children.clear();
    _tabContent.append(_tabs[newSelectedIndex].content);

    _tabChoosers[oldSelectedIndex].classes.toggle("tab-chooser--selected", false);
    _tabChoosers[newSelectedIndex].classes.toggle("tab-chooser--selected", true);

    _selectedTabID = id;
  }

  void selectTab(String id) {
    _selectTab(id);
  }
}
