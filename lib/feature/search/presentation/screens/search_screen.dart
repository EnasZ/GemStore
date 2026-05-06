import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore/core/widgets/custom_app_bar.dart';
import 'package:gemstore/core/widgets/custom_text_feild.dart';
import 'package:gemstore/feature/home/presentation/manager/product_cubit.dart';
import 'package:gemstore/core/widgets/shared_screens/products_result_screen.dart';
import 'package:gemstore/feature/search/presentation/widgets/filter_drawer.dart';

// ... (نفس الـ imports)

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  void _executeSearch(BuildContext context, String query) async {
    if (query.trim().isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.black)),
    );

    // ملاحظة: تأكدي أن الـ Repository يستخدم ilike في Supabase
    await context.read<ProductCubit>().getProducts(filters: {'name': query});

    if (!mounted) return;
    Navigator.pop(context); // إغلاق اللودينج

    final state = context.read<ProductCubit>().state;

    if (state is ProductLoaded) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductsResultScreen(subCategory: query),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // الـ endDrawer موجود هنا
      endDrawer: const FilterDrawer(),
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Search"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextFeild(
                    controller: _searchController,
                    hintText: "Search items...",
                    icon: Icons.search,
                    filled: true,
                    fillColor: const Color(0xFFF3F3F3),
                    radius: 15,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      _executeSearch(context, value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                
                Container(
                      height: 55,
                      width: 55,
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
                      child: IconButton(
                        icon: const Icon(Icons.tune, color: Colors.black),
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                      ),
                    ),
                 
                // -------------------------------------------------------
              ],
            ),
            const Spacer(),
            Column(
              children: [
                Icon(
                  Icons.manage_search,
                  size: 100,
                  color: Colors.grey.shade200,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Type and hit enter to search",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}