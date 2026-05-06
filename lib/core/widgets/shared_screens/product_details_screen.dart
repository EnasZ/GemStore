import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore/core/common/entities/product_entity.dart';
import 'package:gemstore/core/widgets/custom_app_bar.dart';
import 'package:gemstore/core/widgets/custom_button.dart';
import 'package:gemstore/feature/cart/presentation/manager/cart_cubit.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Details",
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {}, 
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleAndPrice(),
                  const SizedBox(height: 10),
                  _buildRating(),
                  const SizedBox(height: 20),
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description ?? "No description available for this product.",
                    style: TextStyle(color: Colors.grey.shade600, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAction(context),
    );
  }

  Widget _buildProductImage() {
    return Hero( // إضافة Hero Animation لجعل الانتقال جميلاً
      tag: product.id,
      child: Container(
        width: double.infinity,
        height: 400,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          image: DecorationImage(
            image: NetworkImage(product.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            product.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          "\$${product.price}",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.star, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(
                product.rating.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          "(${product.reviewsCount} Reviews)",
          style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: CustomButton(
        text: "Add to cart",
        onPressed: () async { // أضيفي async هنا
          // استدعاء الدالة
          await context.read<CartCubit>().addProduct(product.id.toString());
          
          // إظهار الرسالة
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Processing..."),
              duration: Duration(milliseconds: 500),
            ), 
          );
          
        },
              
      ),
    );
  }
}