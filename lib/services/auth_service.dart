import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _createUserDocument(User user, String name) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Only create if it doesn't exist (prevents overwriting on re-signup)
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
      });
    }
  }

  Future<String?> signUpWithEmailAndPassword({
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
        // Save user doc in Firestore
        await _createUserDocument(user, name);

        // Optionally send verification email
        await user.sendEmailVerification();
      }

      return user?.email;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email address.';
      } else {
        return 'Firebase Auth error: ${e.message}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = userCredential.user;

      return user?.email;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided.';
      } else {
        return 'Firebase Auth error: ${e.message}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
