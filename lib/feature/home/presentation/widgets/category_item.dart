import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onTap;
  final bool isSelected;

  const CategoryItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // الدائرة المحيطة بالأيقونة
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 50, // حجم ثابت للدائرة لضمان التناسق
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF3A3A3A) : Colors.white,
              boxShadow: [
                if (!isSelected)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
              ],
            ),
            child: Center(
              child: SizedBox(
                width: 24, // حجم الأيقونة الداخلي
                height: 24,
                child: ColorFiltered(
                  // تغيير لون الأيقونة إذا كانت مختارة
                  colorFilter: ColorFilter.mode(
                    isSelected ? Colors.white : Colors.black,
                    BlendMode.srcIn,
                  ),
                  child: icon,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // اسم التصنيف
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'ProductSans', // أو الخط المستخدم في المشروع
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xFF3A3A3A) : const Color(0xFF9B9B9B),
            ),
          ),
        ],
      ),
    );
  }
}