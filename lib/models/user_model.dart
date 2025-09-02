import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String dept;         
  final String yearOfPassing; 
  final String gender;        
  final String bio;           
  final String avatar;        
  final bool isOnboarded;     
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.dept,
    required this.yearOfPassing,
    required this.gender,
    required this.bio,
    required this.avatar,
    required this.isOnboarded,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  return UserModel(
    uid: data['uid'] ?? '',
    email: data['email'] ?? '',
    name: data['name'] ?? '',
    dept: data['dept'] ?? '',
    yearOfPassing: data['yearOfPassing'] ?? '',
    gender: data['gender'] ?? '',
    bio: data['bio'] ?? '',
    avatar: data['avatar'] ?? '',
    isOnboarded: data['isOnboarded'] ?? false,
    createdAt: data['createdAt'] != null
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now(), // fallback
    updatedAt: data['updatedAt'] != null
        ? (data['updatedAt'] as Timestamp).toDate()
        : DateTime.now(), // fallback
  );
}

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'dept': dept,
      'yearOfPassing': yearOfPassing,
      'gender': gender,
      'bio': bio,
      'avatar': avatar,
      'isOnboarded': isOnboarded,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// 👇 Keep this inside the class
  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? dept,
    String? yearOfPassing,
    String? gender,
    String? bio,
    String? avatar,
    bool? isOnboarded,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      dept: dept ?? this.dept,
      yearOfPassing: yearOfPassing ?? this.yearOfPassing,
      gender: gender ?? this.gender,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
