import 'dart:html';

class Link {
  String label;
  String url;

  Link(this.label, this.url);
}

class ButtonLinksView {
  List<Link> _links;
  String _selected;
  bool _openInNewTab;

  DivElement renderElement;

  ButtonLinksView(this._links, this._selected, {bool openInNewTab = false}) {
    _openInNewTab = openInNewTab;
    renderElement = DivElement();

    _links.forEach((link) {
      var linkContent = SpanElement()..innerText = link.label;
      var linkElement = AnchorElement(href: link.url)
        ..append(linkContent)
        ..className = "button-link";
      if (Uri.parse(link.url).path == _selected) {
        linkElement.classes.add("button-link--selected");
      }
      if (_openInNewTab) {
        linkElement.setAttribute('target', '_blank');

        if (link.url != _selected) {
          var linkIcon = Element.html('<i class="fas fa-external-link-square-alt"></i>');
          linkContent.append(linkIcon);
        }
      }
      renderElement.append(linkElement);
    });
  }
}
