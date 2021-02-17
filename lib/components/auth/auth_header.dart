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

    _signOutButton = new ButtonElement()
      ..text = 'Sign in'
      ..onClick.listen((_) => this.onSignin());

    _signOutButton = new ButtonElement()
      ..text = 'Sign out'
      ..onClick.listen((_) => this.onSignout());
    authElement.append(_signOutButton);
  }

  void signIn(String userName, String userPicUrl) {
    // Set the user's profile pic and name
    _userPic.style.backgroundImage = 'url($userPicUrl)';
    _userName.text = userName;

    // Show user's profile pic, name and sign-out button.
    _userName.attributes.remove('hidden');
    _userPic.attributes.remove('hidden');
    _signInButton.attributes['hidden'] = 'true';
    _signOutButton.attributes.remove('hidden');
  }

  void signOut() {
    // Hide user's profile pic, name and sign-out button.
    _userName.attributes['hidden'] = 'true';
    _userPic.attributes['hidden'] = 'true';
    _signInButton.attributes.remove('hidden');
    _signOutButton.attributes['hidden'] = 'true';
  }
}
