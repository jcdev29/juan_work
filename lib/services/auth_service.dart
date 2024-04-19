import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      debugPrint('Login failed: $e');
      throw 'Login failed. Please check your email and password.';
    }
  }

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      debugPrint('Sign up failed: $e');
      throw 'Sign up failed. Please try again later.';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> updateUserProfile(String username, String bio) async {
    try {
      final user = _auth.currentUser;
      await user?.updateDisplayName(username);
      await FirebaseFirestore.instance.collection('Users').doc(user?.email).update({
        'username': username,
        'bio': bio,
      });
    } catch (e) {
      debugPrint('Failed to update user profile: $e');
      throw 'Failed to update user profile. Please try again later.';
    }
  }
}
