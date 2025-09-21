import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final bool isLoading;
  final VoidCallback action;
  final String text;

  const Button({
    super.key,
    required this.isLoading,
    required this.action,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: isLoading ? null : action,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xFF1947E5),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.black, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black, // softer shadow
                blurRadius: 0,     // softness of shadow edges
                offset: const Offset(0, 4), // vertical shift
              ),
            ],
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
