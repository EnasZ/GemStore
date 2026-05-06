import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore/feature/auth/presentation/screens/profile_screen.dart';
import 'package:gemstore/feature/cart/presentation/screens/cart_screen.dart';
import 'package:gemstore/feature/home/presentation/screens/home_screen.dart';
import 'package:gemstore/feature/home/presentation/widgets/home_drawer.dart';
import 'package:gemstore/feature/search/presentation/screens/discover.dart';
import 'package:gemstore/feature/search/presentation/widgets/filter_drawer.dart';
import '../manager/navigation_cubit.dart';

class MainNavigationScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<NavigationCubit, int>(
        builder: (context, currentIndex) {
          // نجهز الصفحات الآن بدون BlocProvider داخلي لأنهم ورثوه بالفعل من الأعلى
          final List<Widget> pages = [
            const HomeScreen(),
            const DiscoveryScreen(),
            const CartScreen(), 
            ProfileScreen(),
          ];
          return Scaffold(
            key: _scaffoldKey, 
            drawer: const HomeDrawer(),
            endDrawer: const FilterDrawer(),
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(
                currentIndex == 0
                    ? 'Home'
                    : currentIndex == 1
                    ? 'Discover'
                    : currentIndex == 2
                    ? 'Cart'
                    : 'Profile',
              ),
              leading:  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black, size: 24),
                    onPressed: () {
                     _scaffoldKey.currentState?.openDrawer();     
                   },
                  
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.black,
                    size: 24,
                  ),
                  onPressed: () {
                    // يمكنك إضافة وظيفة لعرض الإشعارات هنا
                  },
                ),
              ],
            ),

            body: IndexedStack(index: currentIndex, children: pages),
            bottomNavigationBar: Container(
              // إضافة حواف علوية دائرية وظلال كما في الصورة
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: BottomNavigationBar(
                  currentIndex: currentIndex,
                  onTap: (index) =>
                      context.read<NavigationCubit>().changePage(index),
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.white,
                  selectedItemColor: Colors.black,
                  unselectedItemColor: const Color(
                    0xFFD1D1D1,
                  ), // لون رمادي فاتح جداً كالصورة
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  elevation: 0,
                  iconSize: 28, // حجم الأيقونات
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home_filled),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_bag_outlined),
                      activeIcon: Icon(Icons.shopping_bag),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      activeIcon: Icon(Icons.person),
                      label: '',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
    );
  }
}
