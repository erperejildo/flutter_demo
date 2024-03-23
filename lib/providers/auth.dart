import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_demo/classes/loading.dart';
import 'package:flutter_demo/services/firestore.dart';
import 'package:flutter_demo/types/firestore_user.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth extends ChangeNotifier {
  bool userLoggedIn = FirebaseAuth.instance.currentUser != null ? true : false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<dynamic> logIn(BuildContext context) async {
    final loading = Loading();
    await loading.load(
      context,
      translate('loads.log_in'),
    );

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // ignore: use_build_context_synchronously
    if (googleAuth == null) return loading.cancel(context);

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((data) async {
      notifyListeners();
      loading.cancel(context);
      final bool newUser = await Firestore().checkNewUser(data.user!.uid);
      if (newUser) {
        final FirestoreUser user = FirestoreUser(
          uid: data.user!.uid,
          displayName: data.user?.displayName ?? '',
          photoURL: data.user?.photoURL ?? '',
        );
        await Firestore().updateUser(user);
      }
      return data;
    });
  }

  Future<void> logOut(BuildContext context) async {
    final loading = Loading();
    await loading.load(
      context,
      translate('loads.log_out'),
    );

    await auth.signOut().then((_) {
      notifyListeners();
      loading.cancel(context);
    });
  }
}

final Auth game = Auth();
