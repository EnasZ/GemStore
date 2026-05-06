import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore/core/cache/cache_user_repo.dart';
import 'package:gemstore/feature/auth/cubit/auth_cubit.dart';
import 'package:gemstore/feature/auth/presentation/screens/welcome.dart';
import 'package:gemstore/feature/cart/data/repositories/cart_repository.dart';
import 'package:gemstore/feature/cart/presentation/manager/cart_cubit.dart';
import 'package:gemstore/feature/home/data/repositories/home_repository_impl.dart';
import 'package:gemstore/feature/home/presentation/manager/product_cubit.dart';
import 'package:gemstore/feature/layout/presentation/manager/navigation_cubit.dart';
import 'package:gemstore/feature/layout/presentation/pages/main_navigation_screen.dart';
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
    return MultiBlocProvider(
      // We use MultiBlocProvider to manage multiple cubits
      providers: [
        BlocProvider(create: (context) => NavigationCubit()), // أضيفيه هنا
        // 1. Auth Cubit for Login/Register
        BlocProvider(create: (context) => AuthCubit()),

        // 2. Product Cubit for Home Data fetching
        BlocProvider(create: (context) => ProductCubit(HomeRepositoryImpl())),
        BlocProvider(create: (context) => CartCubit(CartRepository())..fetchCart()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gem Store',
        // Check login status to decide the initial screen
        home: isLoggin ?  MainNavigationScreen() : const Welcome(),
      ),
    );
  }
}
