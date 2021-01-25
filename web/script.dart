import 'dart:html';
import 'package:katikati_ui_lib/snack_bar.dart';

DivElement snack_bar = querySelector('#snack_bar');

void main() {
  // snack bar
  SnackbarView snackbarView = SnackbarView();
  snack_bar.append(snackbarView.snackbarElement);
  snackbarView.showSnackbar(
      "Welcome to KatiKati UI library!", SnackbarNotificationType.success);
}
