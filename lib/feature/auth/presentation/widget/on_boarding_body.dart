import 'package:flutter/material.dart';
import 'package:gemstore/core/theme/app_colors.dart';
import 'package:gemstore/core/theme/media.dart';
import 'package:gemstore/core/theme/app_styles.dart';

class OnBoardBody extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;

  const OnBoardBody({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //SizedBox(height: context.heightPct(0.05)),
        Text(title, style: AppStyles.headlineMedium),
        SizedBox(height: context.heightPct(0.01)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            subTitle,
            textAlign: TextAlign.center,
            style: AppStyles.bodyMedium,
          ),
        ),
        SizedBox(height: context.heightPct(0.05)),
        Container(
          width: context.widthPct(0.6),
          height: context.heightPct(0.4),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image(
              image: AssetImage(image),
              height: context.heightPct(0.3),
            ),
          ),
        ),
      ],
    );
  }
}
