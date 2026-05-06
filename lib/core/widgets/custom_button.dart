import 'package:flutter/material.dart';
import 'package:gemstore/core/theme/app_colors.dart';
import 'package:gemstore/core/theme/app_styles.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final double radius;

  final double height;

  final double width;
  final Color colorButton;
  final double? opacity;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.radius = 30,
    this.height = 50,
    this.width = double.infinity,
    this.colorButton = AppColors.button,
    this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorButton.withOpacity(opacity ?? 1),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(color: Colors.white),
          ),
        ),
        child: Text(text, style: AppStyles.buttonText),
      ),
    );
  }
}
