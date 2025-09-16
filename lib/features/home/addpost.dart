import 'package:evently/models/post_model.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:evently/services/post_service.dart';
import 'package:evently/widgets/dropdown.dart';
import 'package:evently/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _postService = PostService();

  final categories = const [
    'All',
    'Announcements',
    'Events',
    'Academics',
    'Clubs',
    'Community'
  ];

  // Controllers
  final _descController = TextEditingController();
  final _titleController = TextEditingController();
  final _tagController = TextEditingController();

  String? _selectedCategory;

  int votes = 0;
  int comments = 0;

  @override
  void dispose() {
    _descController.dispose();
    _titleController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();
    final tag = _tagController.text.trim();

    if (title.isEmpty ||
        desc.isEmpty ||
        tag.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final user = context.read<UserProvider>().user;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    final post = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      author: user.name,
      authorId: user.uid,
      authorPfp: user.avatar,
      desc: desc,
      title: title,
      category: _selectedCategory ?? 'All',
      createdAt: DateTime.now(),
      votes: votes,
      comments: comments,
      tag: tag,
    );

    _postService.createPost(post);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Post Created Successfully!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            AppTextField(controller: _titleController, label: "Title"),
            AppTextField(controller: _descController, label: "Description"),
            AppDropdownField(
              label: "Category",
              value: _selectedCategory,
              items: categories,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            AppTextField(controller: _tagController, label: "Tag"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitForm(context),
              child: const Text("Create Post"),
            ),
          ],
        ),
      ),
    );
  }
}
