import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore/core/theme/app_styles.dart';
import 'package:gemstore/core/theme/media.dart';
import 'package:gemstore/core/widget/custom_text_feild.dart';
import 'package:gemstore/feature/auth/cubit/auth_cubit.dart';
import 'package:gemstore/feature/auth/presentation/screens/verification_code.dart';

class ForgotPassword extends StatelessWidget {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  ForgotPassword({super.key});

  // Helper function to validate email format
  bool _isValidEmail(String email) {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Navigate to Verification Code screen automatically
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  VerificationCode(email: emailController.text.trim()),
            ),
          );
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.heightPct(0.05)),
                    Text("Forgot password?", style: AppStyles.headlineLarge),
                    SizedBox(height: context.heightPct(0.02)),
                    Text(
                      "Enter your email. Once the email is valid, we will automatically send the verification code.",
                      style: AppStyles.bodyMedium,
                    ),
                    SizedBox(height: context.heightPct(0.06)),
                    // The magic happens here in onChanged
                    CustomTextFeild(
                      controller: emailController,
                      labelText: "Enter your email here",
                      maxLines: 1,
                      onChanged: (value) {
                        // Check if the entered email is valid and no loading is in progress
                        if (_isValidEmail(value) && state is! AuthLoading) {
                          context.read<AuthCubit>().resetPassword(
                            email: value.trim(),
                          );
                        }
                      },
                    ),

                    SizedBox(height: context.heightPct(0.03)),

                    // Showing a loader instead of a button when the email is detected correctly
                    if (state is AuthLoading)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
