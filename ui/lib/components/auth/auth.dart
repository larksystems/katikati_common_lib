import 'dart:html';
import 'package:katikati_ui_lib/components/brand_asset/brand_asset.dart';

const LARK_DOMAIN_INFO = SignInDomainInfo("Lark Systems", "lark.systems");
const KATIKATI_DOMAIN_INFO = SignInDomainInfo("Katikati", "katikati.world");
const AVF_DOMAIN_INFO = SignInDomainInfo("Africa's Voices", "africasvoices.org");
const UCAM_DOMAIN_INFO = SignInDomainInfo("University of Cambridge", "cam.ac.uk");
const GMAIL_DOMAIN_INFO = SignInDomainInfo("Gmail", "gmail.com");

class SignInDomainInfo {
  final String displayName;
  final String domain;
  const SignInDomainInfo(this.displayName, this.domain);
}

class AuthMainView {
  DivElement authElement;

  BrandInfo brand;
  String title;
  String description;
  List<SignInDomainInfo> domainsInfo;
  void Function(SignInDomainInfo) onSigninClick;

  AuthMainView(this.brand, this.title, this.description, this.domainsInfo, this.onSigninClick) {
    authElement = new DivElement()..classes.add('auth-main');

    var logosContainer = new DivElement();
    authElement.append(logosContainer);

    var avfLogo = brand.logo(className: 'partner-logo');
    logosContainer.append(avfLogo);

    var projectTitle = new DivElement()
      ..classes.add('project-title')
      ..append(new HeadingElement.h1()..text = title);
    authElement.append(projectTitle);

    var projectDescription = new DivElement()
      ..classes.add('project-description')
      ..append(new ParagraphElement()..text = description);
    authElement.append(projectDescription);

    for (var domain in domainsInfo) {
      var signInButton = new ButtonElement()
        ..text = "Sign in with ${domain.displayName}"
        ..onClick.listen((_) => onSigninClick(domain));
      authElement.append(signInButton);
    }
  }
}
