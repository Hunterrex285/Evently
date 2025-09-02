import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class PostService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Post>> getAllPosts() async {
    QuerySnapshot snapshot = await _db.collection("posts").get();

    return snapshot.docs
        .map((doc) =>
            Post.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> createPost(Post post) async {
    await _db.collection("posts").add(post.toMap());
  }

  Future<List<Post>> getPostsByUser(String userId) async {
    QuerySnapshot snapshot = await _db
        .collection("posts")
        .where("userId", isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) =>
            Post.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}