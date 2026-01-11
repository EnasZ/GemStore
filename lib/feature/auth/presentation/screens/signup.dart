import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore/core/app_images.dart';
import 'package:gemstore/core/theme/app_styles.dart';
import 'package:gemstore/core/theme/media.dart';
import 'package:gemstore/core/widget/custom_button.dart';
import 'package:gemstore/core/widget/custom_text_feild.dart';
import 'package:gemstore/core/widget/icon_button.dart';
import 'package:gemstore/feature/auth/cubit/auth_cubit.dart';
import 'package:gemstore/feature/auth/presentation/screens/login.dart';
import 'package:gemstore/feature/auth/presentation/screens/profile_screen.dart';
import 'package:gemstore/feature/auth/presentation/widget/custom_row_data.dart';

class Signup extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final userNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Signup({super.key});

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
                    Text("Create", style: AppStyles.headlineLarge),
                    Text("your account", style: AppStyles.headlineLarge),

                    SizedBox(height: context.heightPct(0.04)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomTextFeild(
                          controller: userNameController,
                          labelText: "User Name",
                          maxLines: 1,
                        ),
                        SizedBox(height: context.heightPct(0.02)),
                        CustomTextFeild(
                          controller: emailController,
                          labelText: "Email",
                          maxLines: 1,
                        ),
                        SizedBox(height: context.heightPct(0.02)),
                        CustomTextFeild(
                          controller: passwordController,
                          labelText: "Password",
                          isPassword: true,
                        ),
                        SizedBox(height: context.heightPct(0.02)),
                        CustomTextFeild(
                          controller: confirmPasswordController,
                          labelText: "Confirm Password",
                          isPassword: true,
                        ),
                        SizedBox(height: context.heightPct(0.04)),
                        state is AuthLoading
                            ? Center(child: CircularProgressIndicator())
                            : Center(
                                child: CustomButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      if (passwordController.text !=
                                          confirmPasswordController.text) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Password and Confirm Password do not match",
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      BlocProvider.of<AuthCubit>(
                                        context,
                                      ).signUp(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        userName: userNameController.text,
                                      );
                                    }
                                  },
                                  width: context.widthPct(0.5),
                                  text: "Sign Up",
                                ),
                              ),
                        SizedBox(height: context.heightPct(0.02)),
                        Center(
                          child: Text(
                            "or sign up with",
                            style: AppStyles.bodyMedium,
                          ),
                        ),
                        SizedBox(height: context.heightPct(0.02)),

                        // --- GOOGLE LOGIN SECTION ---
                        Row(
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
                        SizedBox(height: context.heightPct(0.04)),

                        CustomRowData(
                          text: " Already have an account ?",
                          textButton: "Login",
                          screenName: Login(),
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
