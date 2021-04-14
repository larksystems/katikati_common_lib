import 'dart:developer';
import 'dart:html';
import 'package:katikati_ui_lib/components/logger.dart';

var logger = Logger('Tabs');

class TabsView {
  DivElement renderElement;

  List<String> _tabLabels;
  List<DivElement> _tabContents;
  int _selectedIndex;
  String _tabContentClassname;

  List<SpanElement> _tabChoosers = [];
  DivElement _tabContent;

  TabsView(this._tabLabels, this._tabContents, {int defaultSelectedIndex = 0, String tabContentClassname}) {
    if (_tabLabels.length != _tabContents.length) {
      logger.error("Mismatch in tab labels and contents");
      renderElement = DivElement()..innerText = "Error rendering tabs";
      return;
    }

    if (defaultSelectedIndex >= _tabLabels.length || defaultSelectedIndex < 0) {
      logger.error("Selected index greater than avaiable tabs, defaulting to 0");
      defaultSelectedIndex = 0;
    }

    _selectedIndex = defaultSelectedIndex;
    _tabContentClassname = tabContentClassname;

    var tabsHeader = DivElement();
    _tabLabels.asMap().forEach((index, label) {
      var tabChooser = SpanElement()
        ..innerText = label
        ..className = "tab-chooser"
        ..onClick.listen((_) {
          _selectTab(index);
        });
      if (index == _selectedIndex) {
        tabChooser.classes.add("tab-chooser--selected");
      }
      _tabChoosers.add(tabChooser);
      tabsHeader.append(tabChooser);
    });

    _tabContent = DivElement()
      ..className = "tab-content"
      ..append(_tabContents[_selectedIndex]);
    if (_tabContentClassname != null) {
      _tabContent.classes.add(_tabContentClassname);
    }

    renderElement = DivElement()..append(tabsHeader)..append(_tabContent);
  }

  void _selectTab(int index) {
    _tabContent.children.clear();
    _tabContent.append(_tabContents[index]);

    _tabChoosers[_selectedIndex].classes.toggle("tab-chooser--selected", false);
    _tabChoosers[index].classes.toggle("tab-chooser--selected", true);

    _selectedIndex = index;
  }

  void selectTab(int index) {
    if (index < 0 || index >= _tabLabels.length) {
      logger.error("Selected index greater than avaiable tabs, defaulting to 0");
      index = 0;
    }

    _selectTab(index);
  }
}
