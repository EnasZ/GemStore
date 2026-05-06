import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPress;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPress,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      // زر الرجوع المخصص
      leading: showBackButton
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 20,
              ),
              onPressed: onBackPress ?? () => Navigator.pop(context),
            )
          : null,
      // العنوان
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'ProductSans', // تأكدي من إضافة الخط في pubspec.yaml
        ),
      ),
      // الأزرار الإضافية (مثل زر التصفية أو البحث)
      actions: actions,
    );
  }

  // هذا السطر ضروري جداً عند إنشاء AppBar مخصص
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
