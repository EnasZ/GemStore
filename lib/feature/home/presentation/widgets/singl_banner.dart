import 'package:flutter/material.dart';
import 'package:gemstore/core/theme/app_styles.dart';
import 'package:gemstore/core/theme/media.dart';

class SingleBanner extends StatelessWidget {
  final String imageUrl;
  final String topTitle;
  final String mainTitle;
  final VoidCallback? onTap; // موجود ولكنه كان منسياً
  final double height;
  final double? widthImage; // العرض ثابت ليملأ المساحة الأفقية
  final Color? backgroundColor;

  const SingleBanner({
    super.key,
    required this.imageUrl,
    required this.topTitle,
    required this.mainTitle,
    this.onTap,
    required this.height,
    this.backgroundColor,
    this.widthImage,
  });

  @override
  Widget build(BuildContext context) {
    // 1. تغليف الـ Container بـ GestureDetector لتفعيل الضغط
    return GestureDetector(
      onTap: onTap,
      behavior:
          HitTestBehavior.opaque, // يضمن التقاط الضغطة حتى في المساحات الفارغة
      child: Container(
        width: double.infinity,
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: backgroundColor ?? const Color(0xFFF8F8FA),
        ),
        child: Stack(
          children: [
            // 1. الصورة
            Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                // ملاحظة: غيريها لـ Image.asset إذا كانت الصور محلية في التطبيق
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: height,
                  width: context.widthPct(
                    widthImage ?? 0.4,
                  ), // العرض ثابت ليملأ المساحة الأفقية
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                ),
              ),
            ),

            // 2. النصوص
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(width: 2, height: 15, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        topTitle,
                        style: AppStyles.buttonText.copyWith(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    mainTitle,
                    style: AppStyles.headlineMedium.copyWith(
                      color: Colors.grey[600],
                      fontSize: 18, // تأكدي من تناسب الحجم
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
