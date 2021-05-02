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
  Map<String, TabView> _tabsLookup;

  String _selectedTabID;
  String _tabContentClassname;

  List<SpanElement> _tabChoosers = [];
  DivElement _tabsHeader;
  DivElement _tabContent;

  Stream<String> _onEmpty;
  StreamController<String> _onEmptyController;
  Stream<String> get onEmpty => _onEmpty;

  TabsView(this._tabs, {String defaultSelectedID, String tabContentClassname}) {
    _updateLookup();

    if (defaultSelectedID != null) {
      _selectedTabID = defaultSelectedID;
    } else {
      _selectedTabID = _tabs.first.id;
    }

    _tabContentClassname = tabContentClassname;

    _tabsHeader = DivElement();
    _tabs.forEach((tab) {
      var tabChooser = _getTabChooser(tab);
      _tabChoosers.add(tabChooser);
      _tabsHeader.append(tabChooser);
    });

    _tabContent = DivElement()
      ..className = "tab-content"
      ..append(_tabsLookup[_selectedTabID].content);
    if (_tabContentClassname != null) {
      _tabContent.classes.add(_tabContentClassname);
    }

    renderElement = DivElement()..append(_tabsHeader)..append(_tabContent);

    this._onEmptyController = StreamController();
    this._onEmpty = _onEmptyController.stream;
  }

  SpanElement _getTabChooser(TabView tab) {
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
    return tabChooser;
  }

  void _updateLookup() {
    _tabsLookup = {};
    _tabs.forEach((tab) => _tabsLookup[tab.id] = tab);
  }

  void _updateTabContent() {
    _tabContent.children.clear();
    if (_tabsLookup.containsKey(_selectedTabID)) {
      _tabContent.append(_tabsLookup[_selectedTabID].content);
    }
  }

  void _selectTab(String id) {
    _selectedTabID = id;
    _tabChoosers.forEach((tabChooser) {
      tabChooser.classes.toggle("tab-chooser--selected", false);
      if (tabChooser.id == "tab-chooser-$id") {
        tabChooser.classes.toggle("tab-chooser--selected");
      }
    });

    _updateTabContent();
  }

  void selectTab(String id) {
    _selectTab(id);
  }

  void removeTab(String id) {
    _tabs.removeWhere((tab) => tab.id == id);
    _tabChoosers.removeWhere((tabChooser) {
      if (tabChooser.id == "tab-chooser-$id") {
        tabChooser.remove();
        return true;
      }
      return false;
    });
    _updateLookup();
    if (_selectedTabID == id) {
      // todo: be a little bit more smart
      _selectTab(_tabs.isNotEmpty ? _tabs.first.id : null);
      _updateTabContent();
    }
    if (_tabs.isEmpty) {
      if (_onEmptyController.hasListener) {
        _onEmptyController.sink.add(null);
      } else {
        logger.warning("No listener for TabView.onEmpty");
      }
    }
  }

  void addTab(TabView tab) {
    _tabs.add(tab);
    _updateLookup();
    var tabChooser = _getTabChooser(tab);
    _tabChoosers.add(tabChooser);
    _tabsHeader.append(tabChooser);
    _selectTab(tab.id);
  }
}
