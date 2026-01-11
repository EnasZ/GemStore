import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore/core/cache/cache_user_repo.dart';
import 'package:gemstore/feature/auth/cubit/auth_cubit.dart';
import 'package:gemstore/feature/auth/presentation/screens/login.dart';
import 'package:gemstore/feature/auth/presentation/screens/welcome.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://qpsmpsmrysqxbhahhblr.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFwc21wc21yeXNxeGJoYWhoYmxyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc4NTM4MzQsImV4cCI6MjA4MzQyOTgzNH0.SiBZyGlIhJyXx7ei-pe6GpcKk9eHuVp0DoWGB6GKMN4",
  );
  await CacheUserRepo.init();
  runApp(const GemStore());
}

class GemStore extends StatelessWidget {
  const GemStore({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final bool isLoggin = CacheUserRepo.isLoggedIn();
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gem Store',
        home: isLoggin ? Login() : Welcome(),
      ),
    );
  }
}
