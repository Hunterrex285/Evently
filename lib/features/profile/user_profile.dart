import 'package:evently/features/posts/post_detail.dart';
import 'package:evently/models/post_model.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:evently/services/post_service.dart';
import 'package:evently/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _postService = PostService();
  final List<Post> posts = [];
  final Map<String, int> _myVotes = {};
  bool _loadingPosts = false;

  void _vote(String id, int direction) {
    setState(() {
      final current = _myVotes[id] ?? 0;
      final newVote = (current == direction) ? 0 : direction;
      _myVotes[id] = newVote;

      final post = posts.firstWhere((p) => p.id == id);
      post.votes += (newVote - current);
    });
  }

  Future<void> _fetchPosts(String userId) async {
    setState(() => _loadingPosts = true);
    final fetchedPosts = await _postService.getPostsByUser(userId);
    setState(() {
      posts
        ..clear()
        ..addAll(fetchedPosts);
      _loadingPosts = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final user = context.read<UserProvider>().user;
    if (user != null && posts.isEmpty && !_loadingPosts) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print(user.avatar);
        _fetchPosts(user.uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;

        if (userProvider.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (user == null) {
          return const Scaffold(
            body: Center(child: Text("User not logged in")),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF9F5EC),
          body: SafeArea(
            child: _loadingPosts
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        // Profile Header
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                                clipBehavior: Clip.hardEdge,
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white, // background
                                  borderRadius: BorderRadius.circular(80),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  user.avatar,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(user.dept),
                                        const SizedBox(width: 12),
                                        Text("Batch: ${user.yearOfPassing}"),
                                        const SizedBox(width: 12),
                                        Text(user.gender == "Male"
                                            ? "Guy"
                                            : "Gal"),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.green[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text("User ID: ${user.uid}"),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Posts Section Title
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Posts",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Posts list
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DetailPage(),
                                    ),
                                  );
                                },
                                child: PostCard(
                                  post: posts[index],
                                  myVote: _myVotes[posts[index].id] ?? 0,
                                  onUpvote: () => _vote(posts[index].id, 1),
                                  onDownvote: () => _vote(posts[index].id, -1),
                                  bgColor: Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
