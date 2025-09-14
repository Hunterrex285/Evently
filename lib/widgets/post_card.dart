import 'package:evently/models/post_model.dart';
import 'package:evently/widgets/tag_chip.dart';
import 'package:evently/widgets/vote_column.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard(
      {super.key,
      required this.post,
      required this.myVote,
      required this.onUpvote,
      required this.onDownvote,
      required this.bgColor});

  final Post post;
  final int myVote; // -1, 0, +1
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(
          color: const Color.fromARGB(255, 0, 0, 0),
          width: 1.5, 
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black,
              offset: Offset(2, 4),
              blurStyle: BlurStyle.solid)
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                CircleAvatar(
                    radius: 28, backgroundColor: Colors.indigo.shade200),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 16),
                      softWrap: true,
                    ),
                    const SizedBox(height: 8),
                    TagChip(text: post.tag),
                  ],
                ),
              ]),
              const SizedBox(height: 8),
              Text(post.title,
                  style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(post.desc,
                  style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.comment, size: 18, color: Colors.black54),
                  const SizedBox(width: 4),
                  Text('${post.comments}'),
                  const SizedBox(width: 12),
                  const Icon(Icons.schedule, size: 18, color: Colors.black54),
                  const SizedBox(width: 4),
                  Text(_timeAgo(post.createdAt)),
                ],
              ),
            ]),
          ),
          VoteColumn(
              score: post.votes,
              myVote: myVote,
              onUp: onUpvote,
              onDown: onDownvote),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  static String _timeAgo(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    return '${d.inDays}d';
  }
}
