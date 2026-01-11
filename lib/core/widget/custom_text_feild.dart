import 'package:flutter/material.dart';
import 'package:gemstore/core/theme/app_colors.dart';
import 'package:gemstore/core/theme/app_styles.dart';

class CustomTextFeild extends StatefulWidget {
  const CustomTextFeild({
    super.key,
    this.icon,
    this.isPassword = false,
    required this.controller,
    this.onChanged,
    this.siffixIcon,
    this.hintText,
    this.suffixOnPressed,
    this.contentPadding,
    this.radius = 40,
    this.minLines,
    this.maxLines,
    this.filled,
    this.fillColor,
    this.labelText,
    this.border,
  });

  final TextEditingController controller;
  final String? hintText;
  final IconData? icon;
  final bool isPassword;
  final IconData? siffixIcon;
  final void Function(String)? onChanged;
  final void Function()? suffixOnPressed;
  final EdgeInsetsGeometry? contentPadding;
  final double? radius;
  final int? minLines;
  final int? maxLines;
  final bool? filled;
  final Color? fillColor;
  final String? labelText;
  final InputBorder? border;

  @override
  State<CustomTextFeild> createState() => _CustomTextFeildState();
}

class _CustomTextFeildState extends State<CustomTextFeild> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: widget.minLines,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      controller: widget.controller,
      obscureText: widget.isPassword ? !isVisible : false,
      onChanged: widget.onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "${widget.labelText} is required";
        }
        return null;
      },
      style: AppStyles.bodyLarge,
      decoration: InputDecoration(
        contentPadding: widget.contentPadding,
        filled: widget.filled,
        fillColor: widget.fillColor,
        prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
        prefixIconColor: AppColors.textSecondary,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.textSecondary,
                ),
              )
            : IconButton(
                onPressed: widget.suffixOnPressed,
                icon: Icon(widget.siffixIcon),
                color: AppColors.textSecondary,
              ),
        hintText: widget.hintText,
        hintStyle: AppStyles.hint,
        labelText: widget.labelText,
        labelStyle: AppStyles.bodyLarge,
        border: widget.border ?? UnderlineInputBorder(),
      ),
    );
  }
}
