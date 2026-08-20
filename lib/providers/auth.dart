import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/classes/loading.dart';
import 'package:flutter_demo/services/firestore.dart';
import 'package:flutter_demo/types/firestore_user.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth extends ChangeNotifier {
  bool get userLoggedIn => FirebaseAuth.instance.currentUser != null;
  final FirebaseAuth auth = FirebaseAuth.instance;
  static bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    await GoogleSignIn.instance.initialize();
    _initialized = true;
  }

  Future<UserCredential?> logIn(BuildContext context) async {
    final loading = Loading();
    await loading.load(
      context,
      translate('loads.log_in'),
    );

    await _init();

    final GoogleSignInAccount googleUser;
    try {
      googleUser = await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (e) {
      // ignore: use_build_context_synchronously
      await loading.cancel(context);
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final data = await FirebaseAuth.instance.signInWithCredential(credential);

    final bool newUser = await Firestore().checkNewUser(data.user!.uid);
    if (newUser) {
      final FirestoreUser user = FirestoreUser(
        uid: data.user!.uid,
        displayName: data.user?.displayName ?? '',
        photoURL: data.user?.photoURL ?? '',
      );
      await Firestore().updateUser(user);
    }

    loading.cancel(context);
    notifyListeners();
    return data;
  }

  Future<void> logOut(BuildContext context) async {
    final loading = Loading();
    await loading.load(
      context,
      translate('loads.log_out'),
    );

    await auth.signOut();

    loading.cancel(context);
    notifyListeners();
  }
}

final Auth game = Auth();
