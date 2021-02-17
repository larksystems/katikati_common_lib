import 'dart:html';
import 'package:katikati_ui_lib/components/snackbar/snackbar.dart';
import 'package:katikati_ui_lib/components/banner/banner.dart';
import 'package:katikati_ui_lib/components/auth/auth.dart';
import 'package:katikati_ui_lib/components/auth/auth_header.dart';

DivElement snackbarContainer = querySelector('#snackbar-container');
ButtonElement snackbarTrigger = querySelector('#show-snackbar');
DivElement bannerContainer = querySelector('#banner-container');
ButtonElement showBannerTrigger = querySelector('#show-banner');
ButtonElement hideBannerTrigger = querySelector('#hide-banner');
DivElement authViewContainer = querySelector('#auth-view');
DivElement authHeaderViewContainer = querySelector('#auth-header');
ButtonElement authHeaderSimulateSignInTrigger = querySelector('#auth-header-simulate-signin');
ButtonElement authHeaderSimulateSignOutTrigger = querySelector('#auth-header-simulate-signout');

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
  AuthMainView authMainView = AuthMainView("assets/logo.png", "Title", "Description appear here", [SignInDomain.gmail, SignInDomain.lark], (domain) {
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
}
