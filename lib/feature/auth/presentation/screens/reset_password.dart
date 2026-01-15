import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore/core/theme/app_colors.dart';
import 'package:gemstore/core/theme/app_styles.dart';
import 'package:gemstore/core/theme/media.dart';
import 'package:gemstore/core/widget/custom_button.dart';
import 'package:gemstore/core/widget/custom_text_feild.dart';
import 'package:gemstore/feature/auth/cubit/auth_cubit.dart';
import 'package:gemstore/feature/auth/presentation/screens/profile_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final ValueNotifier<bool> isFormValid = ValueNotifier(false);

  ResetPasswordScreen({super.key});

  void _validate(String _) {
    isFormValid.value =
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            _showSuccessBottomSheet(context);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Create new password", style: AppStyles.headlineLarge),
                  SizedBox(height: context.heightPct(0.02)),
                  Text(
                    "Your new password must be different from previously used password",
                    style: AppStyles.bodyMedium,
                  ),
                  SizedBox(height: context.heightPct(0.04)),

                  CustomTextFeild(
                    controller: passwordController,
                    labelText: "Password",
                    isPassword: true,
                    onChanged: _validate, // استدعاء التحقق عند كل تغيير
                  ),
                  SizedBox(height: context.heightPct(0.02)),
                  CustomTextFeild(
                    controller: confirmPasswordController,
                    labelText: "Confirm Password",
                    isPassword: true,
                    onChanged: _validate,
                  ),

                  SizedBox(height: context.heightPct(0.05)),

                  ValueListenableBuilder<bool>(
                    valueListenable: isFormValid,
                    builder: (context, isValid, child) {
                      return Center(
                        child: state is AuthLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                                text: "Reset Password",
                                colorButton: isValid
                                    ? AppColors.button
                                    : Colors.grey.shade400,
                                onPressed: isValid
                                    ? () {
                                        if (passwordController.text ==
                                            confirmPasswordController.text) {
                                          context
                                              .read<AuthCubit>()
                                              .createNewPassword(
                                                password: passwordController
                                                    .text
                                                    .trim(),
                                              );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Passwords don't match",
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    : null,
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // دالة لإظهار الواجهة المنبثقة عند النجاح (مثل الصورة الثانية)
  void _showSuccessBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.black,
            ),
            const SizedBox(height: 20),
            const Text(
              "Your password has been changed",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Welcome back! Discover now!",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: "Browse home",
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
