import 'dart:html';

class ScrollOverflowIndicator {
  DivElement _container;
  DivElement _shadowTop;
  DivElement _shadowBottom;
  DivElement get container => _container;

  ScrollOverflowIndicator() {
    _shadowTop = DivElement()..classes.add("shadow")..classes.add("shadow-top");
    _shadowBottom = DivElement()..classes.add("shadow")..classes.add("shadow-bottom");
    _container = DivElement()..classes.add("scroll-indicator-container");

    _container.onScroll.listen((Event e) {
      var target = e.target as DivElement;
      _setShadows(target);
    });
  }

  void setContent(DivElement content) {
    _container.children.clear();
    _container..append(_shadowTop)..append(_shadowBottom)..append(content);
    _setShadows(_container);
  }

  void updateShadows() {
    _setShadows(_container);
  }

  void _setShadows(DivElement target) {
    if (target.scrollTop > 0) {
      _shadowTop.style.removeProperty("display");
    } else {
      _shadowTop.style.display = "none";
    }
    if (target.scrollTop + target.clientHeight == target.scrollHeight) {
      _shadowBottom.style.display = "none";
    } else {
      _shadowBottom.style.removeProperty("display");
    }
    _shadowBottom.style.top = "${target.clientHeight}px";
  }
}
