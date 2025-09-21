import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Create User Document
  Future<void> _createUserDocument(User user, String name) async {
    final docRef = _db.collection('users').doc(user.uid);

    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({
        'uid': user.uid,
        'name': name,
        'email': user.email,
        'dept': '',
        'bio': '',
        'avatar': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'user', // to differentiate later
      });
    }
  }

  /// Create Club Document
  Future<void> _createClubDocument(
      User user, String clubName) async {
    final docRef = _db.collection('clubs').doc(user.uid);

    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({
        'uid': user.uid,
        'clubName': clubName,
        'email': user.email,
        'bio': '',
        'avatar': user.photoURL ?? '',
        'verified': false, // they will request verification later
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'club', // to differentiate
      });
    }
  }

  /// Normal User Signup
  Future<String?> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        await _createUserDocument(user, name);
        await user.sendEmailVerification();
      }

      return user?.email;
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    } catch (e) {
      return 'Error: $e';
    }
  }

  /// Club Signup
  Future<String?> signUpClub({
    required String clubName,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        await _createClubDocument(user, clubName);
        await user.sendEmailVerification();
      }

      return user?.email;
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    } catch (e) {
      return 'Error: $e';
    }
  }

  /// Sign In (works for both user & club)
  Future<String?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      return userCredential.user?.email;
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    } catch (e) {
      return 'Error: $e';
    }
  }

  /// Handle Auth Errors
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      default:
        return 'Firebase Auth error: ${e.message}';
    }
  }



}
