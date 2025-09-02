import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String author;
  final String desc;          // ✅ new field
  final String title;
  final String category;
  final DateTime createdAt;   // ✅ switched from Timestamp → DateTime
  int votes;                  // ✅ replaces upvotes
  final int comments;         // ✅ new field
  final String tag;       // ✅ simplified (instead of list of tags)

  Post({
    required this.id,
    required this.author,
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
    Post post = Post(
      id: docId,
      author: data['author'] ?? data['authorId'] ?? '',
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
    
    return post;
  }

  /// Post → Firestore
  Map<String, dynamic> toMap() {
    return {
      'author': author,
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
