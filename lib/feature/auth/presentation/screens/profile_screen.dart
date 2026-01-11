import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore/core/app_images.dart';
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
        if (state is AuthSuccess) {
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (context) => Signup()));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text("Profile"), centerTitle: true),
          body: Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(AppImages.logo),
                ),
                SizedBox(height: 20),
                Text(
                  user?.userMetadata?["userName"] ?? "name",
                  style: AppStyles.headlineMedium,
                ),
                SizedBox(height: 10),
                Text(
                  user?.userMetadata?["email"] ?? "email@gmail.com",
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
