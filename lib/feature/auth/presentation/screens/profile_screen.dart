import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore/core/theme/app_styles.dart';
import 'package:gemstore/core/widget/custom_button.dart';
import 'package:gemstore/feature/auth/cubit/auth_cubit.dart';
import 'package:gemstore/feature/auth/presentation/screens/signup.dart';

import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final user = Supabase.instance.client.auth.currentUser;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          // عند تسجيل الخروج، الحالة تعود لـ AuthInitial كما في الـ Cubit
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Signup()),
            (route) => false, // مسح كل الشاشات السابقة
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text("Profile"), centerTitle: true),
          body: Center(
            child: Column(
              children: [
                Text(
                  user?.userMetadata?["full_name"] ??
                      user?.userMetadata?["userName"] ??
                      "No Name",
                  style: AppStyles.headlineMedium,
                ),
                SizedBox(height: 10),
                Text(
                  user?.email ?? "no-email@example.com",
                  style: AppStyles.bodyMedium,
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: state is AuthLoading
                      ? CircularProgressIndicator()
                      : CustomButton(
                          onPressed: () {
                            BlocProvider.of<AuthCubit>(context).logOut();
                          },
                          text: "Logout",
                        ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
