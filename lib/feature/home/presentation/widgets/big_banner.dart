// lib/features/home/presentation/widgets/home_banner_slider.dart

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gemstore/core/app_images.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeBannerSlider extends StatelessWidget {
  HomeBannerSlider({super.key});

  // ValueNotifier to track the current index without StatefulWidget
  final ValueNotifier<int> _activeIndex = ValueNotifier(0);

  final List<String> banners = [
    AppImages.bigBanner,
    AppImages.bigBanner2,
    AppImages.bigBanner3,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          itemBuilder: (context, index, realIndex) {
            // Write the banner design directly here
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(
                horizontal: 5,
              ), // Space between cards
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(banners[index]),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                    begin: Alignment.centerLeft,
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Autumn \n Collection \n 2022",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              _activeIndex.value = index;
            },
          ),
        ),
        const SizedBox(height: 12),
        // Dots Indicator
        ValueListenableBuilder(
          valueListenable: _activeIndex,
          builder: (context, value, child) {
            return AnimatedSmoothIndicator(
              activeIndex: value,
              count: banners.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 7,
                dotWidth: 7,
                activeDotColor: Colors.black,
              ),
            );
          },
        ),
      ],
    );
  }
}
