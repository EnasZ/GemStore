import 'package:flutter/material.dart';
import 'package:gemstore/core/theme/app_colors.dart';
import 'package:gemstore/core/theme/media.dart';
import 'package:gemstore/feature/auth/presentation/screens/signup.dart';

import '../../../../core/widget/custom_button.dart';
import '../widget/on_boarding_body.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;
  final pageController = PageController();
  void nextPage() {
    if (currentIndex < 2) {
      pageController.nextPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to Signup Screen
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => Signup()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.widthPct(1),
        height: context.heightPct(1),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.6, 0.6],
            colors: [AppColors.white, AppColors.primary],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                children: [
                  OnBoardBody(
                    image: "assets/images/onboarding1.png",
                    title: "Discover something new",
                    subTitle: "Special new arrivals just for you",
                  ),
                  OnBoardBody(
                    image: "assets/images/onboarding2.png",
                    title: "Update trendy outfit",
                    subTitle: "Favorite brands and hottest trends",
                  ),
                  OnBoardBody(
                    image: "assets/images/onboarding3.png",
                    title: "Explore your true style",
                    subTitle: "Relax and let us bring the style to you",
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? AppColors.textSecondary
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButton(
                onPressed: nextPage,
                text: "Shopping now",
                radius: 30,
                width: context.widthPct(0.5),
                opacity: 0.25,
                colorButton: AppColors.white,
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
