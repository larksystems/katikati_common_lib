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

  DivElement _logos;
  DivElement _title;
  DivElement _description;

  void Function(SignInDomainInfo) _onSigninClick;

  AuthMainView(BrandInfo brand, List<SignInDomainInfo> domainsInfo, this._onSigninClick, [String title, String description]) {
    authElement = new DivElement()..classes.add('auth-main');

    _logos = new DivElement();
    brands = [brand];

    _title = new DivElement()
      ..classes.add('project-title')
      ..append(new HeadingElement.h1());

    _description = new DivElement()
      ..classes.add('project-description')
      ..append(new ParagraphElement());

    authElement.append(_logos);
    authElement.append(_title);
    authElement.append(_description);
  }

  void set brands(List<BrandInfo> values) {
    for (var logo in _logos.querySelectorAll('.partner-logo')) {
      logo.remove();
    }
    for (var brand in values) {
      _logos.append(brand.logo(className: 'partner-logo'));
    }
  }

  void set title(String value) => _title.querySelector('h1').text = value;

  void set description(String value) => _description.querySelector('p').text = value;

  void set domainsInfo(List<SignInDomainInfo> values) {
    for (var button in authElement.querySelectorAll('button')) {
      button.remove();
    }

    for (var domain in values) {
      var signInButton = new ButtonElement()
        ..text = "Sign in with ${domain.displayName}"
        ..onClick.listen((_) => _onSigninClick(domain));
      authElement.append(signInButton);
    }
  }
}
