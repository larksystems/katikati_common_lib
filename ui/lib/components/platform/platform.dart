import 'package:firebase/firebase.dart' as firebase;
import 'package:firebase/firestore.dart' as firestore;
import 'package:katikati_ui_lib/components/logger.dart';
import 'package:katikati_ui_lib/components/platform/platform_constants.dart' as platform_constants;

Logger log = new Logger('platform.dart');

firestore.Firestore _firestoreInstance;

void init(String constantsFilePath, Function(firebase.User) onUserSignIn, Function() onUserSignOut) async {
  await platform_constants.init(constantsFilePath);
  firebase.initializeApp(
      apiKey: platform_constants.apiKey,
      authDomain: platform_constants.authDomain,
      databaseURL: platform_constants.databaseURL,
      projectId: platform_constants.projectId,
      storageBucket: platform_constants.storageBucket,
      messagingSenderId: platform_constants.messagingSenderId);

  // Firebase login
  firebaseAuth.onAuthStateChanged.listen((firebase.User user) async {
    // User signed out
    if (user == null) {
      _firestoreInstance = null;
      onUserSignOut();
      log.debug('User signed out');
      return;
    }
    // User signed in
    _firestoreInstance = firebase.firestore();
    onUserSignIn(user);
    log.debug('Signed in as ${user.displayName}(${user.email})');
  });
}

firebase.Auth get firebaseAuth => firebase.auth();
firestore.Firestore get firestoreInstance => _firestoreInstance;

/// Signs the user in.
signIn({String domain}) {
  var provider = new firebase.GoogleAuthProvider();
  if (domain != null) {
    provider.setCustomParameters({'hd': domain});
  }
  firebaseAuth.signInWithPopup(provider);
}

/// Signs the user out.
signOut() {
  firebaseAuth.signOut();
}

/// Returns true if a user is signed-in.
bool isUserSignedIn() {
  return firebaseAuth.currentUser != null;
}
