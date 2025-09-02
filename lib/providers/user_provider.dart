import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _loading = false; // track loading state

  UserModel? get user => _user;
  bool get loading => _loading;

  /// Fetch user by email
  Future<void> setUser(String email) async {
    _loading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _user = UserModel.fromFirestore(snapshot.docs.first);
      } else {
        if (kDebugMode) print("No user found for email: $email");
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching user by email: $e");
    }

    _loading = false;
    notifyListeners();
  }

  /// 🔹 Update onboarding details in Firestore and locally
  Future<void> updateUserDetails(Map<String, dynamic> data) async {
  if (_user == null) return;

  try {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(_user!.uid) // use uid for precise doc reference
        .update(data);

    // update local user object
    _user = _user!.copyWith(
      dept: data["department"] ?? _user!.dept,
      yearOfPassing: data["yearOfPassing"] ?? _user!.yearOfPassing,
      gender: data["gender"] ?? _user!.gender,
      bio: data["bio"] ?? _user!.bio,
      avatar: data["avatar"] ?? _user!.avatar,
      isOnboarded: true
    );

    notifyListeners();
  } catch (e) {
    if (kDebugMode) print("Error updating user details: $e");
  }
}


  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
