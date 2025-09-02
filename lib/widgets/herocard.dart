import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconPath;
  final VoidCallback onTap;

  const HeroCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        clipBehavior: Clip.none, // 👈 allows the SVG to overflow
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    )),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Post Now"),
                ),
              ],
            ),
          ),

          // Floating SVG that leaks outside
          Positioned(
            right: -20, // 👈 push out of bounds
            top: -10,
            child: SvgPicture.asset(
              iconPath,
              height: 196  , // bigger than the card
              width: 196,
            ),
          ),
        ],
      ),
    );
  }
}
