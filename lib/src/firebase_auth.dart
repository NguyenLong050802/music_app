import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../ui/home/home_tab.dart';
import 'firebase_service.dart';

class AuthMethods {

  signInWithGoogle(BuildContext context) async {
    final firebaseAuth = FirebaseAuth.instance;
    final googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken);

    UserCredential result = await firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;

    Map<String, dynamic> userInfoMap = {
      "email": userDetails!.email,
      "name": userDetails.displayName,
      "imgUrl": userDetails.photoURL,
      "id": userDetails.uid,
    };
    await FireBaseService().addUser(userDetails.uid, userInfoMap).then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MyHomePage()));
    });
  }
}
