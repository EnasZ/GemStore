import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore/core/app_images.dart';
import 'package:gemstore/core/theme/media.dart';
import 'package:gemstore/core/widgets/product_card.dart';
import 'package:gemstore/core/widgets/shared_screens/product_details_screen.dart';
import 'package:gemstore/core/widgets/shared_screens/products_result_screen.dart';
import 'package:gemstore/core/widgets/show__all_row.dart';
import 'package:gemstore/feature/home/data/repositories/home_repository_impl.dart';
import 'package:gemstore/feature/home/presentation/manager/product_cubit.dart'; // تأكدي من المسار
import 'package:gemstore/feature/home/presentation/widgets/big_banner.dart';
import 'package:gemstore/feature/home/presentation/widgets/category_item.dart';
import 'package:gemstore/feature/home/presentation/widgets/singl_banner.dart';
import 'package:gemstore/feature/search/presentation/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = "Women";

  // نقل البيانات لتكون ثابتة ومنظمة
  final List<Map<String, dynamic>> categoriesData = [
    {"title": "Women", "icon": AppImages.womenIcon},
    {"title": "Men", "icon": AppImages.menIcon},
    {"title": "Accessories", "icon": AppImages.accessoriesIcon},
    {"title": "Beauty", "icon": AppImages.beautyIcon},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // --- 1. قائمة التصنيفات (Categories) ---
          _buildCategoriesList(),

          SizedBox(height: context.heightPct(0.02)),

          // --- 2. البانر الرئيسي (Slider) ---
          HomeBannerSlider(),

          SizedBox(height: context.heightPct(0.01)),

          // --- 3. قسم المنتجات المميزة (Featured Products) ---
          ShowAllRow(
            title: "Feature Products",
            onShowAllTap: () => _navigateToSearch(context),
          ),

          _buildFeaturedProductsSection(),

          SizedBox(height: context.heightPct(0.02)),

          // --- 4. البانرات الإعلانية (Banners) ---
          _buildBannersSection(context),

          SizedBox(height: context.heightPct(0.02)),
        ],
      ),
    );
  }

  // ويدجت منفصلة للتصنيفات
  Widget _buildCategoriesList() {
    return Center(
      child: SizedBox(
        height: context.heightPct(0.13),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoriesData.length,
          padding: const EdgeInsets.symmetric(horizontal: 80),
          itemBuilder: (context, index) {
            final item = categoriesData[index];
            final bool isSelected = selectedCategory == item['title'];

            return Padding(
              padding: const EdgeInsets.only(right: 15),
              child: CategoryItem(
                title: item['title'],
                icon: Image.asset(item['icon'], width: 24),
                isSelected: isSelected,
                onTap: () => _onCategorySelected(item['title']),
              ),
            );
          },
        ),
      ),
    );
  }

  // ويدجت منفصلة لقسم المنتجات القادم من Cubit
  Widget _buildFeaturedProductsSection() {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return _buildLoadingIndicator();
        } else if (state is ProductLoaded) {
          return SizedBox(
            height: context.heightPct(0.32),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SizedBox(
                    width: 150,
                    // استخدمي الكارت المشترك اللي اتفقنا عليه
                    child: ProductCard(
                      product: product,
                      onTap: () => _navigateToDetails(context, product),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is ProductError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // قسم البانرات مجمع بشكل منظم
  Widget _buildBannersSection(BuildContext context) {
    return Column(
      children: [
        SingleBanner(
          imageUrl: AppImages.newCollectionBanner,
          topTitle: "NEW COLLECTION",
          mainTitle: "HANG OUT \n& PARTY",
          height: context.heightPct(0.25),
          onTap: () => _navigateToResults(context, "n"),
        ),
        ShowAllRow(
          title: "Top Collection",
          onShowAllTap: () => _navigateToResults(context, "t"),
        ),
        SingleBanner(
          imageUrl: AppImages.saleBanner,
          topTitle: "Sale up to 40%",
          mainTitle: "FOR SLIM \n& BEAUTY",
          height: context.heightPct(0.25),
          onTap: () => _navigateToResults(context, "t"),
        ),
        SingleBanner(
          imageUrl: AppImages.summerBanner,
          topTitle: "Summer Collection 2021",
          mainTitle: "Most sexy\n& fabulous\ndesign ",
          height: context.heightPct(0.35),
          onTap: () => _navigateToResults(context, "s"),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: SingleBanner(
                imageUrl: AppImages.tShirtBanner,
                topTitle: "T-Shirts",
                mainTitle: "The Office \nLife",
                height: context.heightPct(0.25),
                widthImage: 0.25,
                onTap: () => _navigateToResults(context, "shirt"),
              ),
            ),
            Expanded(
              child: SingleBanner(
                imageUrl: AppImages.dressBanner,
                topTitle: "Dresses",
                mainTitle: "Elegant\nDesign",
                widthImage: 0.25,
                height: context.heightPct(0.25),
                onTap: () => _navigateToResults(context, "dress"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- دوال المساعدة (Helper Methods) لتقليل زحمة الكود ---

  void _onCategorySelected(String title) {
    setState(() => selectedCategory = title);
    context.read<ProductCubit>().getProducts(
      filters: {'category': title, 'is_featured': true},
    );
  }

  // داخل HomeScreen عند الضغط على البانر
  void _navigateToResults(BuildContext context, String keyword) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => ProductCubit(
            HomeRepositoryImpl(), // قمنا بإنشاء نسخة من الريبوزيتوري هنا
          ),
          child: ProductsResultScreen(subCategory: keyword),
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context, product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(product: product),
      ),
    );
  }

  void _navigateToSearch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: 200,
      child: Center(
        child: CircularProgressIndicator(color: Colors.black.withOpacity(0.5)),
      ),
    );
  }
}
