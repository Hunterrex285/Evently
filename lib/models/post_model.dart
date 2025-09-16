import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String author;
  final String authorId;
  final String authorPfp;     // ✅ new field
  final String desc;
  final String title;
  final String category;
  final DateTime createdAt;
  int votes;
  final int comments;
  final String tag;

  Post({
    required this.id,
    required this.author,
    required this.authorId,
    required this.authorPfp,  // ✅ required
    required this.desc,
    required this.title,
    required this.category,
    required this.createdAt,
    required this.votes,
    required this.comments,
    required this.tag,
  });

  /// Firestore → Post
  factory Post.fromFirestore(Map<String, dynamic> data, String docId) {
    return Post(
      id: docId,
      author: data['author'] ?? data['authorId'] ?? '',
      authorId: data['authorId'] ?? '',
      authorPfp: data['authorPfp'] ?? '',   // ✅ fallback to empty if missing
      desc: data['desc'] ?? '',
      title: data['title'] ?? '',
      category: data['category'] ?? 'Community',
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      votes: (data['votes'] ?? data['upvotes'] ?? 0) as int,
      comments: (data['comments'] ?? 0) as int,
      tag: (data['tag'] ??
          ((data['tags'] != null && data['tags'].isNotEmpty)
              ? data['tags'][0]
              : '')) as String,
    );
  }

  /// Post → Firestore
  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'authorId': authorId,
      'authorPfp': authorPfp,   // ✅ include when writing
      'desc': desc,
      'title': title,
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
      'votes': votes,
      'comments': comments,
      'tag': tag,
    };
  }
}
