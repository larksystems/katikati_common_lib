import 'dart:html';
import 'package:katikati_ui_lib/components/nav/nav_header.dart';
import 'package:katikati_ui_lib/components/snackbar/snackbar.dart';
import 'package:katikati_ui_lib/components/banner/banner.dart';
import 'package:katikati_ui_lib/components/auth/auth.dart';
import 'package:katikati_ui_lib/components/auth/auth_header.dart';
import 'package:katikati_ui_lib/components/brand_asset/brand_asset.dart';

DivElement snackbarContainer = querySelector('#snackbar-container');
ButtonElement snackbarTrigger = querySelector('#show-snackbar');
DivElement bannerContainer = querySelector('#banner-container');
ButtonElement showBannerTrigger = querySelector('#show-banner');
ButtonElement hideBannerTrigger = querySelector('#hide-banner');
DivElement authViewContainer = querySelector('#auth-view');
DivElement authHeaderViewContainer = querySelector('#auth-header');
ButtonElement authHeaderSimulateSignInTrigger = querySelector('#auth-header-simulate-signin');
ButtonElement authHeaderSimulateSignOutTrigger = querySelector('#auth-header-simulate-signout');
DivElement navHeaderViewContainer = querySelector('#nav-header');
DivElement brandAssetsContainer = querySelector('#brand-assets');

void main() {
  // snackbar
  SnackbarView snackbarView = SnackbarView();
  snackbarContainer.append(snackbarView.snackbarElement);
  snackbarTrigger.onClick.listen((_) {
    snackbarView.showSnackbar("Welcome to the Katikati UI library!", SnackbarNotificationType.success);
  });

  // banner
  BannerView bannerView = BannerView();
  bannerContainer.append(bannerView.bannerElement);
  showBannerTrigger.onClick.listen((_) {
    bannerView.showBanner("Welcome to the Katikati UI library!");
  });
  hideBannerTrigger.onClick.listen((_) {
    bannerView.hideBanner();
  });

  // auth view
  AuthMainView authMainView = AuthMainView(Brand.avf, "Title", "Description appear here", [SignInDomain.gmail, SignInDomain.lark], (domain) {
    window.alert("Trying to login with domain: $domain");
  });
  authViewContainer.append(authMainView.authElement);

  // auth inside header
  AuthHeaderView authHeaderView = AuthHeaderView(() {
    window.alert("Firebase login should be called.");
  }, () {
    window.alert("Firebase logout should be called.");
  });
  authHeaderViewContainer.append(authHeaderView.authElement);
  authHeaderSimulateSignInTrigger.onClick.listen((_) {
    authHeaderView.signIn("Username", "assets/profile.png");
  });
  authHeaderSimulateSignOutTrigger.onClick.listen((_) {
    authHeaderView.signOut();
  });

  // nav header
  NavHeaderView navHeaderView = NavHeaderView();
  navHeaderViewContainer.append(navHeaderView.navViewElement);
  navHeaderView.projectLogos = ["assets/logo.png"];
  navHeaderView.projectTitle = "Project name";
  navHeaderView.projectSubtitle = "Subtitle";
  navHeaderView.navContent = DivElement()..appendText("Some content like links, dropdown");
  navHeaderView.authHeader = authHeaderView;

  // logos
  var avfLogo = logo(Brand.avf, height: 64)..style.marginRight = "32px";
  brandAssetsContainer.append(avfLogo);
  var katikatiLogo = logo(Brand.katikati, height: 64)..style.marginRight = "32px";
  brandAssetsContainer.append(katikatiLogo);
  var ifrcLogo = logo(Brand.ifrc, height: 64, className: "logo");
  brandAssetsContainer.append(ifrcLogo);
}
