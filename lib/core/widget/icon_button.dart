import 'package:flutter/material.dart';

/// A custom circular button widget used for social media authentication (Google, Apple, Facebook).
class SocialButton extends StatelessWidget {
  /// The asset path of the social media icon (e.g., 'assets/images/google.png').
  final String imagePath;

  /// The callback function to be executed when the button is pressed.
  final VoidCallback onTap;

  const SocialButton({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Handles the tap event and provides a ripple effect
      onTap: onTap,
      // Ensures the ripple effect is circular to match the container
      customBorder: const CircleBorder(),
      child: Container(
        //padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // Makes the button perfectly circular as seen in the design
          shape: BoxShape.circle,
          // Adds a subtle light grey border
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Image.asset(
          imagePath,
          height: 40, // Standardized icon height
          width: 40, // Standardized icon width
        ),
      ),
    );
  }
}
