import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/club_model.dart';

class ClubProvider with ChangeNotifier {
  ClubModel? _club;
  bool _loading = false;

  ClubModel? get club => _club;
  bool get loading => _loading;

  /// Fetch club by email
  Future<void> setClub(String email) async {
    _loading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("clubs")
          .where("email", isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _club = ClubModel.fromFirestore(snapshot.docs.first);
      } else {
        if (kDebugMode) print("No club found for email: $email");
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching club by email: $e");
    }

    _loading = false;
    notifyListeners();
  }

  /// 🔹 Update club details in Firestore and locally
  Future<void> updateClubDetails(Map<String, dynamic> data) async {
    if (_club == null) return;

    try {
      await FirebaseFirestore.instance
          .collection("clubs")
          .doc(_club!.uid)
          .update(data);

      _club = _club!.copyWith(
        orgName: data["orgName"] ?? _club!.orgName,
        description: data["description"] ?? _club!.description,
        logo: data["logo"] ?? _club!.logo,
        isOnboarded: data["isOnboarded"] ?? _club!.isOnboarded,
        isVerified: data["isVerified"] ?? _club!.isVerified,
        updatedAt: DateTime.now(),
      );

      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error updating club details: $e");
    }
  }

  void clearClub() {
    _club = null;
    notifyListeners();
  }
}
