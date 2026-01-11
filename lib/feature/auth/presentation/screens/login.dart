import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore/core/app_images.dart';
import 'package:gemstore/core/theme/app_styles.dart';
import 'package:gemstore/core/theme/media.dart';
import 'package:gemstore/core/widget/custom_button.dart';
import 'package:gemstore/core/widget/custom_text_feild.dart';
import 'package:gemstore/core/widget/icon_button.dart';
import 'package:gemstore/feature/auth/cubit/auth_cubit.dart';
import 'package:gemstore/feature/auth/presentation/screens/profile_screen.dart';
import 'package:gemstore/feature/auth/presentation/screens/signup.dart';
import 'package:gemstore/feature/auth/presentation/widget/custom_row_data.dart';

class Login extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Log into", style: AppStyles.headlineLarge),

                    Text("your account", style: AppStyles.headlineLarge),

                    SizedBox(height: context.heightPct(0.06)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomTextFeild(
                          controller: emailController,
                          labelText: "Email address",
                          maxLines: 1,
                        ),
                        SizedBox(height: context.heightPct(0.02)),

                        CustomTextFeild(
                          controller: passwordController,
                          labelText: "Password",
                          isPassword: true,
                        ),
                        SizedBox(height: context.heightPct(0.03)),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot Password?",
                            style: AppStyles.bodyMedium,
                          ),
                        ),
                        SizedBox(height: context.heightPct(0.03)),
                        state is AuthLoading
                            ? Center(child: CircularProgressIndicator())
                            : Center(
                                child: CustomButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      BlocProvider.of<AuthCubit>(context).login(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                    }
                                  },
                                  width: context.widthPct(0.5),
                                  text: "Login",
                                ),
                              ),
                        SizedBox(height: context.heightPct(0.02)),
                        Center(
                          child: Text(
                            "or login with",
                            style: AppStyles.bodyMedium,
                          ),
                        ),
                        SizedBox(height: context.heightPct(0.02)),

                        // --- GOOGLE LOGIN SECTION ---
                        Center(
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center, // لتوسيط الأزرار
                            children: [
                              SocialButton(
                                imagePath: AppImages.appleLogo,
                                onTap: () {},
                              ),
                              const SizedBox(width: 20),

                              SocialButton(
                                imagePath: AppImages.googleLogo,
                                onTap: () {
                                  context.read<AuthCubit>().signInWithGoogle();
                                },
                              ),
                              const SizedBox(width: 20),

                              SocialButton(
                                imagePath: AppImages.facebookLogo,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: context.heightPct(0.12)),

                        // --- END OF GOOGLE LOGIN SECTION ---
                        CustomRowData(
                          text: "Don't have an account ?",
                          textButton: "Sign Up",
                          screenName: Signup(),
                        ),
                      ],
                    ),
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
