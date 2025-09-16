class Participant {
  final String uid;
  final String name;
  final String email;
  final String? avatarUrl;

  Participant({
    required this.uid,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  factory Participant.fromMap(Map<String, dynamic> data) {
    return Participant(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }
}
