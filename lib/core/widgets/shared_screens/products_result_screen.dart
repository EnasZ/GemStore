import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore/core/widgets/custom_app_bar.dart';
import 'package:gemstore/core/widgets/products_gridview.dart';
import 'package:gemstore/core/widgets/shared_screens/product_details_screen.dart';
import 'package:gemstore/feature/home/presentation/manager/product_cubit.dart'; // تأكدي من المسار

class ProductsResultScreen extends StatefulWidget {
  final String subCategory;

  const ProductsResultScreen({super.key, required this.subCategory});

  @override
  State<ProductsResultScreen> createState() => _ProductsResultScreenState();
}

class _ProductsResultScreenState extends State<ProductsResultScreen> {
  @override
  void initState() {
    super.initState();
    // تنظيف الحالة السابقة أولاً ثم طلب البيانات الجديدة
    final cubit = context.read<ProductCubit>();
    cubit.resetState();
    cubit.getProducts(filters: {'name': widget.subCategory});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: widget.subCategory, showBackButton: true),
      // مراقبة حالة الـ Cubit لبناء الواجهة
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          } else if (state is ProductLoaded) {
            final products = state.products;

            if (products.isEmpty) {
              return _buildEmptyState();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "${products.length} Items found",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                child: ProductsGridView(
                  products: products,
                  onProductTap: (selectedProduct) { // نستخدم المتغير القادم من الـ GridView
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // بما أننا وضعنا الـ Provider في الـ main، لا داعي لـ BlocProvider.value هنا
                        builder: (context) => ProductDetailsScreen(product: selectedProduct),
                      ),
                    );
                  },
                ),
                ),
              ],
            );
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          }

          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 100,
            color: Colors.grey.shade100,
          ),
          const SizedBox(height: 20),
          Text(
            "No items found in ${widget.subCategory}",
            style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
