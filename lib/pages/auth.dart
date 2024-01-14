//import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthServices{
  Future<String> SignIn(String email,String password);
  Future<String> Signup(String email,String password);
  Future<String> getCurrentUser();
  Future<void> signout();
}
class Auth implements AuthServices{
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  Future<String> SignIn(String email,String password)async{
    UserCredential userCredential=await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user!.uid;
  }
  Future<String> Signup(String email,String password)async{
    UserCredential userCredential=await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user!.uid;
  }
  Future<String> getCurrentUser()async{
    User userCredential=await _firebaseAuth.currentUser!;
    return userCredential.uid;
  }
  Future<void> signout()async{
    _firebaseAuth.signOut();
  }
}