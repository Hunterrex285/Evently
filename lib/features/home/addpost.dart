import 'package:evently/models/post_model.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:evently/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _postService = PostService();
  final _formKey = GlobalKey<FormState>();

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
  final _categoryController = TextEditingController();
  final _tagController = TextEditingController();

    String? _selectedCategory; // 👈 new variable


  int votes = 0;
  int comments = 0;

  @override
  void dispose() {
    _descController.dispose();
    _titleController.dispose();
    _categoryController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final user = context.read<UserProvider>().user; // 👈 Get user once

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in")),
        );
        return;
      }

      final post = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // unique ID
        author: user.name, // ✅ logged-in userId
        desc: _descController.text,
        title: _titleController.text,
        category: _categoryController.text,
        createdAt: DateTime.now(), 
        votes: votes,
        comments: comments,
        tag: _tagController.text,
      );

      _postService.createPost(post);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post Created Successfully!")),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user; // 👈 Reactive user

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (user != null)
                Text("Logged in as: ${user.email}"), // 👈 Example
              
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter title" : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter description" : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Category"),
                value: _selectedCategory,
                items: categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (val) =>
                    val == null || val.isEmpty ? "Select a category" : null,
              ),
              TextFormField(
                controller: _tagController,
                decoration: const InputDecoration(labelText: "Tag"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter tag" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitForm(context),
                child: const Text("Create Post"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
