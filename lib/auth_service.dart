// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
// ignore: depend_on_referenced_packages
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<void> initializeFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform(),
    );
  }

  AuthService() {
    initializeFirebase();
  }

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  //giriş yap fonksiyonu
  Future<User?> signIn(String email, String password) async {
    var user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user;
  }

  //çıkış yap fonksiyonu
  signOut() async {
    return await _auth.signOut();
  }

  //kayıt ol fonksiyonu
  Future<User?> createPerson(String name, String email, String password) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    addInfoGoogle(name, email, user.user!.uid);
    return user.user;
  }

  Future<void> addInfoGoogle(String name, String email, String usrid) async {
    await _firestore
        .collection("Persons")
        .doc(usrid)
        .set({'Name': name, 'email': email});
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signInWithGoogleByAut() async {
    await signInWithGoogle();
    final auth = FirebaseAuth.instance.currentUser;
    String? email = auth!.email;
    String? name = auth.displayName;
    addInfoGoogle(name!, email!, auth.uid);
  }
}
