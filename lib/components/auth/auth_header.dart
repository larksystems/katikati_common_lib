import 'dart:html';

class AuthHeaderView {
  DivElement authElement;
  void Function() onSignout;
  void Function() onSignin;
  DivElement _userPic;
  DivElement _userName;
  ButtonElement _signInButton;
  ButtonElement _signOutButton;

  AuthHeaderView(this.onSignin, this.onSignout) {
    authElement = new DivElement()..classes.add('auth-header');

    _userPic = new DivElement()..classes.add('user-pic');
    authElement.append(_userPic);

    _userName = new DivElement()..classes.add('user-name');
    authElement.append(_userName);

    _signInButton = new ButtonElement()
      ..text = 'Sign in'
      ..onClick.listen((_) => this.onSignin());
    authElement.append(_signInButton);

    _signOutButton = new ButtonElement()
      ..text = 'Sign out'
      ..onClick.listen((_) => this.onSignout());
    authElement.append(_signOutButton);
  }

  void signIn(String userName, String userPicUrl) {
    // Set the user's profile pic and name
    _userPic.style.backgroundImage = 'url($userPicUrl)';
    _userName.text = userName;

    // Show sign-out button
    _signInButton.attributes['hidden'] = 'true';
    _signOutButton.attributes.remove('hidden');
  }

  void signOut() {
    // Remove user's profile pic and name
    _userPic.style.backgroundImage = 'none';
    _userName.text = null;

    // Show sign-in button
    _signInButton.attributes.remove('hidden');
    _signOutButton.attributes['hidden'] = 'true';
  }
}
