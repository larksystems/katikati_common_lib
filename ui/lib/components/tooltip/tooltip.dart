import 'dart:html';

enum TooltipPosition {top, bottom, left, right}

class Tooltip {
  Element _content;
  String _tooltipText;
  DivElement renderElement;

  Tooltip(this._content, this._tooltipText, {TooltipPosition position = TooltipPosition.right}) {
    renderElement = DivElement()..className = "tooltip";

    var tooltip = SpanElement()
      ..classes.add("tooltip-text")
      ..classes.add(position.toString().split(".")[1])
      ..innerText = _tooltipText;
    renderElement.append(_content);
    renderElement.append(tooltip);
  }
}
