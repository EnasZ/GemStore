import 'package:flutter/material.dart';
import 'package:gemstore/core/theme/app_colors.dart';

import '../../../../core/widget/custom_button';
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
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      color: Color(0xffC53030),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                  image: "assets/images/frame_1.png",
                  title: "Trending News ",
                  subTitle:
                      "Stay in the loop with the biggest breaking stories in a stunning visual slider. Just swipe to explore what’s trending right now!",
                ),
                OnBoardBody(
                  image: "assets/images/frame_2.png",
                  title: "Pick What You Love",
                  subTitle:
                      "No more endless scrolling! Tap into your favorite topics like Tech, Politics, or Sports and get personalized news in seconds",
                ),
                OnBoardBody(
                  image: "assets/images/frame_3.png",
                  title: "Save It. Read It Later. Stay Smart.",
                  subTitle:
                      "Found something interesting? Tap the bookmark and come back to it anytime. Never lose a great read again!",
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
                child: CircleAvatar(
                  backgroundColor: currentIndex == index
                      ? AppColors.textSecondary
                      : AppColors.white,
                  radius: currentIndex == index ? 8 : 8,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              onPressed: nextPage,
              text: currentIndex == 2 ? "Get Started" : "Next",
              radius: 30,
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
