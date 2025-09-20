import 'package:cloud_firestore/cloud_firestore.dart';

class ClubModel {
  final String uid;            // Firebase Auth ID
  final String email;          // Society login email
  final String orgName;        // Club/Society name
  final String description;    // Short intro
  final String logo;           // Avatar/logo image
  final bool isOnboarded;      // After onboarding
  final bool isVerified;       // After admin approval
  final String role;           // NEW: user or club
  final DateTime createdAt;
  final DateTime updatedAt;

  ClubModel({
    required this.uid,
    required this.email,
    required this.orgName,
    required this.description,
    required this.logo,
    required this.isOnboarded,
    required this.isVerified,
    required this.role,          // NEW
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClubModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ClubModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      orgName: data['orgName'] ?? '',
      description: data['description'] ?? '',
      logo: data['logo'] ?? '',
      isOnboarded: data['isOnboarded'] ?? false,
      isVerified: data['isVerified'] ?? false,
      role: data['role'] ?? 'club',        // NEW
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'orgName': orgName,
      'description': description,
      'logo': logo,
      'isOnboarded': isOnboarded,
      'isVerified': isVerified,
      'role': role,                // NEW
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  ClubModel copyWith({
    String? uid,
    String? email,
    String? orgName,
    String? description,
    String? logo,
    bool? isOnboarded,
    bool? isVerified,
    String? role,                // NEW
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClubModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      orgName: orgName ?? this.orgName,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      isVerified: isVerified ?? this.isVerified,
      role: role ?? this.role,          // NEW
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
