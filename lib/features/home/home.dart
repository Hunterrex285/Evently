import 'dart:math';
import 'package:evently/features/home/addpost.dart';
import 'package:evently/models/post_model.dart';
import 'package:evently/services/post_service.dart';
import 'package:evently/widgets/discovery_row.dart';
import 'package:evently/widgets/friends_row.dart';
import 'package:evently/widgets/herocard.dart';
import 'package:evently/widgets/post_card.dart';
import 'package:flutter/material.dart';

class CollegeHomePage extends StatefulWidget {
  const CollegeHomePage({super.key});

  @override
  State<CollegeHomePage> createState() => _CollegeHomePageState();
}

class _CollegeHomePageState extends State<CollegeHomePage> {
  final _postService = PostService();
  final List<Post> posts = [];

  // Define 4 repeating colors
  final postColors = [
    const Color(0xFFFFBD12), // soft yellow
    const Color(0xFFFFC7DE), // soft green
    const Color(0xFF61E4C5), // orange tone
  ];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final fetchedPosts = await _postService.getAllPosts();
    setState(() {
      posts.clear();
      posts.addAll(fetchedPosts);
    });
  }

  final categories = const [
    'All',
    'Announcements',
    'Events',
    'Academics',
    'Clubs',
    'Community'
  ];
  String selectedCategory = 'All';

  final sortModes = const ['Hot', 'Top', 'New'];
  String selectedSort = 'Hot';

  // track user vote per post: -1, 0, +1
  final Map<String, int> _myVotes = {};

  // ------- Sorting helpers -------
  List<Post> get _filteredAndSorted {
    final now = DateTime.now();

    // filter
    final filtered = posts
        .where((p) =>
            selectedCategory == 'All' ? true : p.category == selectedCategory)
        .toList();

    // compute hot score (simple Reddit-like)
    double hotScore(Post p) {
      final ageHours = max(1, now.difference(p.createdAt).inMinutes / 60.0);
      return p.votes / pow(ageHours + 2, 1.5);
    }

    // sort
    if (selectedSort == 'New') {
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else if (selectedSort == 'Top') {
      filtered.sort((a, b) => b.votes.compareTo(a.votes));
    } else {
      filtered.sort((a, b) => hotScore(b).compareTo(hotScore(a)));
    }
    return filtered;
  }

  void _vote(String id, int direction) {
    // direction: +1 (up), -1 (down)
    setState(() {
      final current = _myVotes[id] ?? 0;
      // toggle logic
      final newVote = (current == direction) ? 0 : direction;
      _myVotes[id] = newVote;

      final post = posts.firstWhere((p) => p.id == id);
      // adjust votes: remove previous, add new
      post.votes += (newVote - current);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        HeroCard(
          iconPath: "icons/hero.svg", // <-- pass PNG here
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddPostPage(),
            ));
          },
        ),

        const SizedBox(height: 16),

        _buildCategoryChips(),

        // Friends row
        // FriendsRow(onAdd: () {}),

        const SizedBox(height: 12),

        DiscoveryRow(onViewAll: () {}),

        const SizedBox(height: 12),

        // Sort + Feed
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Feed',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            DropdownButton<String>(
              value: selectedSort,
              borderRadius: BorderRadius.circular(12),
              items: sortModes
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (v) => setState(() => selectedSort = v!),
            ),
          ],
        ),
        const SizedBox(height: 8),

        ..._filteredAndSorted.asMap().entries.map((entry) {
          final index = entry.key;
          final post = entry.value;

          final bgColor = postColors[index % 3];

          return PostCard(
            post: post,
            myVote: _myVotes[post.id] ?? 0,
            onUpvote: () => _vote(post.id, 1),
            onDownvote: () => _vote(post.id, -1),
            bgColor: bgColor, 
          );
        }),
      ],
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((c) {
          final selected = c == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              showCheckmark: false,
              label: Text(c),
              selected: selected,
              onSelected: (_) => setState(() => selectedCategory = c),
              selectedColor: Color(0xFF305450),
              labelStyle: TextStyle(
                  color: selected ? Colors.white : Color(0xFF305450),
                  fontWeight: FontWeight.w700),
              backgroundColor: Color(0xFFF9F5EC),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(
                    color:
                        selected ? Colors.transparent : const Color(0xFF305450),
                  )),
            ),
          );
        }).toList(),
      ),
    );
  }
}
