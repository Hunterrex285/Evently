import 'package:flutter/material.dart';

class VoteColumn extends StatelessWidget {
  const VoteColumn({required this.score, required this.myVote, required this.onUp, required this.onDown});
  final int score;
  final int myVote;
  final VoidCallback onUp;
  final VoidCallback onDown;

  @override
  Widget build(BuildContext context) {
    final upColor = myVote == 1 ? const Color.fromARGB(255, 255, 102, 1) : Colors.black45;
    final downColor = myVote == -1 ? Colors.blueGrey : Colors.black45;
    return Column(
      children: [
        IconButton(iconSize: 30, onPressed: onUp, icon: Icon(Icons.arrow_drop_up, color: upColor)),
        Text('$score', style: const TextStyle(fontWeight: FontWeight.w700)),
        IconButton(iconSize: 30, onPressed: onDown, icon: Icon(Icons.arrow_drop_down, color: downColor)),
      ],
    );
  }
}