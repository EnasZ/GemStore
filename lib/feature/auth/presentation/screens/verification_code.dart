import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore/core/theme/app_styles.dart';
import 'package:gemstore/core/widget/custom_text_feild.dart';
import 'package:gemstore/feature/auth/cubit/auth_cubit.dart';
import 'package:gemstore/feature/auth/presentation/screens/reset_password.dart';

class VerificationCode extends StatelessWidget {
  final String email;
  VerificationCode({super.key, required this.email});

  // 1. Generate 6 controllers and 6 focus nodes for the 6-digit OTP
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          // Navigate to the next screen (e.g., New Password Screen) on success
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
          );
        } else if (state is AuthError) {
          // Show error message if the code is incorrect or expired
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Verification Code", style: AppStyles.headlineLarge),
                const SizedBox(height: 10),
                Text(
                  "Please enter the 6-digit verification code sent to $email",
                  style: AppStyles.bodyMedium,
                ),
                const SizedBox(height: 60),

                // 2. ListView.builder to display the 6 circular input fields horizontally
                SizedBox(
                  height: 65,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable scrolling for better UI
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: _buildOtpItem(context, index),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 50),
                // 3. Show loading indicator while verifying the code
                if (state is AuthLoading)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Helper widget for a single OTP input circle
  Widget _buildOtpItem(BuildContext context, int index) {
    return SizedBox(
      width: 50, // Slightly narrower to fit 6 circles on screen
      height: 60,
      child: CustomTextFeild(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        maxLines: 1,
        textAlign: TextAlign.center,
        // 4. Large and bold font style for the digit
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        contentPadding: EdgeInsets.zero,
        radius: 50, // Makes the field circular
        filled: true,
        fillColor: Colors.grey.shade100,
        onChanged: (value) {
          // 5. Auto-focus logic: Move to next field when a digit is entered
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          }
          // 6. Move back to the previous field when a digit is deleted
          if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }

          // 7. Auto-trigger verification once all 6 fields are filled
          String otpCode = _controllers.map((e) => e.text).join();
          if (otpCode.length == 6) {
            context.read<AuthCubit>().verifyCode(email: email, token: otpCode);
          }
        },
      ),
    );
  }
}
