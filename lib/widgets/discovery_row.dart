import 'package:evently/widgets/discover_card.dart';
import 'package:flutter/material.dart';

class DiscoveryRow extends StatelessWidget {
  const DiscoveryRow({required this.onViewAll});
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final cards = [
      DiscoveryCard(title: 'Fest Poster Design', subtitle: 'Creative Club'),
      DiscoveryCard(title: 'Data Structures Notes', subtitle: 'Shared by Pranav'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Expanded(child: Text('Discovery', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18))),
          TextButton(onPressed: onViewAll, child: const Text('View All'), style: TextButton.styleFrom(foregroundColor: const Color(0xFF305450))),
        ]),
        SingleChildScrollView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: Row(children: cards.map((c) => Padding(padding: const EdgeInsets.only(right: 12), child: c)).toList()),
        ),
      ],
    );
  }
}