import 'package:flutter/material.dart';
import '../common/entities/product_entity.dart';
import 'product_card.dart';

class ProductsGridView extends StatelessWidget {
  final List<ProductEntity> products;
  final Function(ProductEntity) onProductTap;

  const ProductsGridView({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: false, // لكي تعمل داخل SingleChildScrollView
      physics: BouncingScrollPhysics(), // لتعطيل التمرير الداخلي
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // عدد الأعمدة
        childAspectRatio: 0.7, // تناسب العرض مع الطول
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        return ProductCard(
          product: products[index],
          onTap: () => onProductTap(products[index]),
        );
      },
    );
  }
}
