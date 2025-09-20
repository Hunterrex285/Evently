import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

  class HeroCard extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;

  const HeroCard({
    super.key,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // 👈 allows the SVG to overflow
      children: [
        Container(
          height: 188,
          padding: const EdgeInsets.all(24),
          decoration: ShapeDecoration(
            color: const Color(0xFFF8592B),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 2,
                color: const Color(0xFF18191F),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            shadows: [
              BoxShadow(
                color: Color(0xFF18191F),
                blurRadius: 0,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    SizedBox(
                      width: 279,
                      child: Text(
                        'What’s\nNew',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w900,
                          height: 1.11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 99,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xFF18191F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Text(
                      'POST',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w800,
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Floating SVG that leaks outside
        Positioned(
          right: 0, // 👈 push out of bounds
          top: -10,
          child: SvgPicture.asset(
            iconPath,
            height: 205, // bigger than the card
            width: 205,
          ),
        ),
      ],
    );
  }
}
