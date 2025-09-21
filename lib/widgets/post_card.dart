import 'package:evently/features/posts/post_detail.dart';
import 'package:evently/models/post_model.dart';
import 'package:evently/widgets/tag_chip.dart';
import 'package:evently/widgets/vote_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.myVote,
    required this.onUpvote,
    required this.onDownvote,
    required this.bgColor, // Default yellow from design
  });

  final Post post;
  final int myVote; // -1, 0, +1
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DetailPage(post: post)));
      },
      child: Container(
        height: 175,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: bgColor,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 2,
              color: Color(0xFF18191F),
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0xFF18191F),
              blurRadius: 0,
              offset: Offset(0, 2),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main content section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 2,
                              color: Color(0xFF18191F),
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: SvgPicture.asset(
                            post.authorPfp,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.author,
                              style: const TextStyle(
                                color: Color(0xFF18191F),
                                fontSize: 15,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w800,
                                height: 1.33,
                              ),
                            ),
                            Text(
                              _timeAgo(post.createdAt),
                              style: const TextStyle(
                                color: Color(0xFF474A57),
                                fontSize: 11,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Post title
                  Text(
                    post.title,
                    style: const TextStyle(
                      color: Color(0xFF18191F),
                      fontSize: 21,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.desc,
                    style: const TextStyle(
                      color: Color(0xFF18191F),
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                  const SizedBox(height: 16),

                  // Bottom actions
                  Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        child: const Icon(
                          Icons.comment_outlined,
                          size: 18,
                          color: Color(0xFF18191F),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${post.comments} Comments',
                        style: const TextStyle(
                          color: Color(0xFF18191F),
                          fontSize: 13,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w800,
                          height: 1.38,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            VoteColumn(
              score: post.votes,
              myVote: myVote,
              onUp: onUpvote,
              onDown: onDownvote,
            ),
          ],
        ),
      ),
    );
  }

  static String _timeAgo(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }
}
