import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore/core/app_images.dart';
import 'package:gemstore/core/widgets/shared_screens/products_result_screen.dart';
import 'package:gemstore/feature/home/data/repositories/home_repository_impl.dart';
import 'package:gemstore/feature/home/presentation/manager/product_cubit.dart';
import 'package:gemstore/feature/search/presentation/screens/search_screen.dart';
import 'package:gemstore/feature/home/presentation/widgets/singl_banner.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  String? selectedMainCategory;
  String? selectedSubCategory; // لحفظ اسم القسم المختار للعنوان
  List<String> currentSubCategories = [];

  void _onBannerTap(String category, List<String> subs) {
    setState(() {
      if (selectedMainCategory == category) {
        selectedMainCategory = null;
        currentSubCategories = [];
      } else {
        selectedMainCategory = category;
        currentSubCategories = subs;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // حذفنا الـ BlocListener تماماً من هنا
    return Column(
      children: [
        _buildSearchHeader(context),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildBannerWithMenu("CLOTHES", AppImages.clothes, [
                  "shirt",
                  "Dress",
                  "Jacket",
                  "Skirt",
                ], const Color(0xFFA3A798)),
                const SizedBox(height: 16),
                _buildBannerWithMenu("SHOES", AppImages.shoesBanner, [
                  "Sneakers",
                  "Boots",
                  "Sandals",
                ], const Color(0xFF9C9492)),
                const SizedBox(height: 16),
                _buildBannerWithMenu("ACCESSORIES", AppImages.bagBanner, [
                  "Bag",
                  "Jewelry",
                  "Watches",
                ], const Color(0xFF44565C)),
              ],
            ),
          ),
        ),
      ],
    );
  }
  // --- دوال مساعدة وبناء الويدجتس ---

  Widget _buildSearchHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              ),
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Text(
                      "Search items...",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildFilterButton(context),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child:IconButton(
            icon: const Icon(Icons.tune, color: Colors.black),
            onPressed: () {
              // سيبحث عن أقرب Scaffold في الأعلى (وهو الموجود في الـ Main Shell)
              Scaffold.of(context).openEndDrawer(); 
            },
          ),
        
    );
  }

  Widget _buildBannerWithMenu(
    String title,
    String image,
    List<String> subs,
    Color backgroundColor,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _onBannerTap(title, subs),
          child: SingleBanner(
            imageUrl: image,
            topTitle: '',
            mainTitle: title,
            height: 150,
            backgroundColor: backgroundColor,
          ),
        ),
        if (selectedMainCategory == title) _buildSubCategoryList(),
      ],
    );
  }

  Widget _buildSubCategoryList() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: currentSubCategories.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey.shade200,
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final subName = currentSubCategories[index];
          return ListTile(
            title: Text(subName),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
            onTap: () {
              selectedSubCategory = subName; // حفظ الاسم
              // استدعاء الكيوبيت لجلب البيانات
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => ProductCubit(
                      HomeRepositoryImpl(), // قمنا بإنشاء نسخة من الريبوزيتوري هنا
                    ),
                    child: ProductsResultScreen(subCategory: subName),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
