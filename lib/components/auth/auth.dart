import 'dart:html';
import 'package:katikati_ui_lib/components/brand_asset/brand_asset.dart';

enum SignInDomain { lark, katikati, avf, ucam, gmail }
const signInDomainsInfo = {
  SignInDomain.lark: {"displayName": "Lark Systems", "domain": "lark.systems"},
  SignInDomain.katikati: {"displayName": "Katikati", "domain": "katikati.world"},
  SignInDomain.avf: {"displayName": "Africa's Voices", "domain": "africasvoices.org"},
  SignInDomain.ucam: {"displayName": "University of Cambridge", "domain": "cam.ac.uk"},
  SignInDomain.gmail: {"displayName": "Gmail", "domain": "gmail.com"},
};

class AuthMainView {
  DivElement authElement;

  Brand brand;
  String title;
  String description;
  List<SignInDomain> domains;
  void Function(SignInDomain) onSigninClick;

  AuthMainView(this.brand, this.title, this.description, this.domains, this.onSigninClick) {
    authElement = new DivElement()..classes.add('auth-main');

    var logosContainer = new DivElement()..classes.add('auth-main__logos');
    authElement.append(logosContainer);

    var avfLogo = logo(this.brand, className: 'partner-logo');
    logosContainer.append(avfLogo);

    var projectTitle = new DivElement()
      ..classes.add('project-title')
      ..append(new HeadingElement.h1()..text = title);
    authElement.append(projectTitle);

    var projectDescription = new DivElement()
      ..classes.add('project-description')
      ..append(new ParagraphElement()..text = description);
    authElement.append(projectDescription);

    for (var domain in domains) {
      var signInButton = new ButtonElement()
        ..text = "Sign in with ${signInDomainsInfo[domain]['displayName']}"
        ..onClick.listen((_) => onSigninClick(domain));
      authElement.append(signInButton);
    }
  }
}
