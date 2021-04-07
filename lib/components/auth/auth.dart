import 'dart:html';

enum KnownSignInDomain { lark, katikati, avf, ucam, gmail }
const knownSignInDomainInfo = {
  KnownSignInDomain.lark: SignInDomainInfo("Lark Systems", "lark.systems"),
  KnownSignInDomain.katikati: SignInDomainInfo("Katikati", "katikati.world"),
  KnownSignInDomain.avf: SignInDomainInfo("Africa's Voices", "africasvoices.org"),
  KnownSignInDomain.ucam: SignInDomainInfo("University of Cambridge", "cam.ac.uk"),
  KnownSignInDomain.gmail: SignInDomainInfo("Gmail", "gmail.com")
};

class SignInDomainInfo {
  final String displayName;
  final String domain;
  const SignInDomainInfo(this.displayName, this.domain);
}

class AuthMainView {
  DivElement authElement;

  String logoPath;
  String title;
  String description;
  List<SignInDomainInfo> domainsInfo;
  void Function(SignInDomainInfo) onSigninClick;

  AuthMainView(this.logoPath, this.title, this.description, this.domainsInfo, this.onSigninClick) {
    authElement = new DivElement()..classes.add('auth-main');

    var logosContainer = new DivElement()..classes.add('auth-main__logos');
    authElement.append(logosContainer);

    var avfLogo = new ImageElement(src: logoPath)..classes.add('partner-logo');
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
