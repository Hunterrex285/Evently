import 'package:flutter/material.dart';

class FriendsRow extends StatelessWidget {
  const FriendsRow({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final avatars = List.generate(6, (i) => CircleAvatar(radius: 22, backgroundColor: Colors.primaries[i % Colors.primaries.length]));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: Text('Friendlist', style: TextStyle(fontWeight: FontWeight.w600))),
            TextButton(onPressed: onAdd, child: const Text('Add Friend')),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...avatars.map((a) => Padding(padding: const EdgeInsets.only(right: 12), child: a)),
            ],
          ),
        ),
      ],
    );
  }
}