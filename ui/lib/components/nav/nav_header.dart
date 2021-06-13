import 'dart:html';
import 'package:katikati_ui_lib/components/auth/auth_header.dart';

class NavHeaderView {
  DivElement navViewElement;

  DivElement _appLogos;
  DivElement _projectTitle;
  DivElement _projectSubtitle;
  DivElement _navContent;
  DivElement _authHeader;

  NavHeaderView() {
    navViewElement = DivElement()..classes.add('nav');

    _appLogos = DivElement()..classes.add('nav__app_logos');
    _projectTitle = DivElement();
    _projectSubtitle = DivElement();
    _navContent = DivElement()..classes.add('nav__contents');
    _authHeader = DivElement()..classes.add('nav__auth_header');

    navViewElement.append(_appLogos);
    navViewElement.append(_projectTitle);
    navViewElement.append(_projectSubtitle);
    navViewElement.append(_navContent);
    navViewElement.append(_authHeader);
  }

  void set projectLogos(List<String> logoPaths) {
    _appLogos.children.clear();
    logoPaths.forEach((path) => _appLogos.append(ImageElement(src: path)));
  }
  void set projectTitle(String projectTitle) {
    _projectTitle.text = projectTitle;
    _projectTitle.classes.toggle('nav__project_title', true);
  }
  void set projectSubtitle(String projectSubtitle) {
    _projectSubtitle.text = projectSubtitle;
    _projectSubtitle.classes.toggle('nav__project_subtitle', true);
  }
  void set navContent(DivElement content) {
    _navContent.children.clear();
    _navContent.append(content);
  }
  void set authHeader(AuthHeaderView authHeaderView) {
    _authHeader.append(authHeaderView.authElement);
  }
}
