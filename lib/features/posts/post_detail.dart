import 'package:flutter/material.dart';
import 'package:evently/models/post_model.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFF1947E5),
        title: const Text("Post Details",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 24)),
      ),
      body: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(0), bottom: Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 0,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event image placeholder
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                        ),
                      ),
                  
                      // Event title
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 4.0),
                        child: Text(
                          post.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 27,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                        child: Text(
                          post.desc,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
