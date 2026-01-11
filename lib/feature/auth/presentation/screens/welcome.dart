import 'package:flutter/material.dart';
import 'package:gemstore/core/theme/app_colors.dart';
import 'package:gemstore/core/theme/media.dart';
import 'package:gemstore/core/widget/custom_button.dart';
import 'package:gemstore/feature/auth/presentation/screens/on_board_screen.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.widthPct(1),
        height: context.heightPct(1),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/welcome.png"),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
          color: Colors.black,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Welcome to GemStore! ",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            Text(
              " The home for a fashionista ",
              style: TextStyle(fontSize: 16, color: AppColors.white),
            ),
            SizedBox(height: context.heightPct(0.05)),
            CustomButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OnBoardingScreen()),
                );
              },
              radius: 30,
              width: context.widthPct(0.5),
              opacity: 0.25,
              colorButton: AppColors.white,
              text: "Get Started",
            ),
            SizedBox(height: context.heightPct(0.1)),
          ],
        ),
      ),
    );
  }
}
