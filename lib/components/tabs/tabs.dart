import 'dart:html';

class TabView {
  String id;
  String label;
  DivElement content;

  TabView(this.id, this.label, this.content);
}

class TabsView {
  DivElement renderElement;
  List<TabView> _tabs;
  List<String> get _tabIds => _tabs.map((tab) => tab.id).toList();
  Map<String, TabView> get _tabsById => Map.fromEntries(_tabs.map((t) => MapEntry(t.id, t)));

  String _selectedTabId;
  List<SpanElement> _tabChoosers;
  DivElement _tabsHeader;
  DivElement _tabContent;

  TabsView(this._tabs, {String defaultSelectedID}) {
    _tabs = _tabs ?? [];
    if (defaultSelectedID != null && _tabIds.contains(defaultSelectedID)) {
      _selectedTabId = defaultSelectedID;
    }
    if (_selectedTabId == null && _tabs.isNotEmpty) {
      _selectedTabId = _tabIds.first;
    }
    _tabsHeader = DivElement()..classes.add("tab-choosers");
    _tabContent = DivElement()..classes.add("tab-content");
    _tabChoosers = [];

    _setTabs(_tabs);
    renderElement = DivElement()
      ..classes.add("tabs-container")
      ..append(_tabsHeader)
      ..append(_tabContent);
  }

  void _updateSelectedId(String id) {
    if (id != null && _tabIds.contains(id)) {
      _selectedTabId = id;
      return;
    }
    if (!_tabIds.contains(_selectedTabId)) {
      _selectedTabId = _tabs.isNotEmpty ? _tabs.first.id : null;
    }
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
    } else {
      _tabContent.innerText = "No tabs present";
    }
  }

  void _selectTab(String id) {
    _updateSelectedId(id);
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

  void _setTabs(List<TabView> tabs) {
    _tabs = tabs ?? [];
    _tabsHeader.children.clear();
    _tabChoosers.clear();
    _tabContent.children.clear();

    if (_tabs.isEmpty) {
      _updateSelectedId(null);
      _updateTabContent();
      return;
    }

    _updateSelectedId(null);
    _tabs.forEach((tab) {
      var tabChooser = _createTabChooserElement(tab);
      _tabChoosers.add(tabChooser);
      _tabsHeader.append(tabChooser);
    });

    _updateTabContent();
  }

  void setTabs(List<TabView> tabs) {
    _setTabs(tabs);
  }
}
