// lib/core/widgets/show_all_row.dart

import 'package:flutter/material.dart';
import 'package:gemstore/core/theme/app_colors.dart';
import 'package:gemstore/core/theme/app_styles.dart';

class ShowAllRow extends StatelessWidget {
  final String title;
  final VoidCallback onShowAllTap;

  const ShowAllRow({
    super.key,
    required this.title,
    required this.onShowAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: onShowAllTap,
            child: Text(
              "Show all",
              style: AppStyles.bodyMedium.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}