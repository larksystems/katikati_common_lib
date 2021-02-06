import 'dart:html';
import 'package:katikati_ui_lib/components/snackbar/snackbar.dart';
import 'package:katikati_ui_lib/components/banner/banner.dart';

DivElement snackbarContainer = querySelector('#snackbar-container');
ButtonElement snackbarTrigger = querySelector('#show-snackbar');
DivElement bannerContainer = querySelector('#banner-container');
ButtonElement showBannerTrigger = querySelector('#show-banner');
ButtonElement hideBannerTrigger = querySelector('#hide-banner');

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
}
