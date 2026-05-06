import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore/core/theme/app_colors.dart';
import 'package:gemstore/feature/cart/presentation/manager/cart_cubit.dart';
import 'package:gemstore/core/widgets/custom_button.dart';
import 'package:gemstore/feature/cart/presentation/manager/cart_state.dart';
import 'package:gemstore/feature/cart/presentation/widgets/item_cart.dart'; // تأكدي من المسار

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CartLoaded) {
          if (state.items.isEmpty) {
            return const Center(child: Text("سلتك فارغة"));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    // داخل ListView.builder في CartScreen
                    final item = state.items[index];
                    final productData = item['products']; // هنا تفاصيل المنتج التي جلبناها بالـ Join

                    return ItemCart(
                      title: productData['name'],          // الوصول للاسم من جدول المنتجات
                      price: "\$${productData['price']}",  // الوصول للسعر
                      imageUrl: productData['image_url'],  // الوصول للصورة
                      quantity: item['quantity'],          // الكمية من جدول السلة نفسه
                      onAdd: () => context.read<CartCubit>().changeQty(item['id'], item['quantity'] + 1),
                      onRemove: () => context.read<CartCubit>().changeQty(item['id'], item['quantity'] - 1),
                      sizeColor: '',
                    );
                  },
                ),
              ),

              // 2. ملخص السعر في الأسفل
              _buildPriceSummary(state.subTotal),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPriceSummary(double subTotal) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          _summaryRow("Product price", "\$${subTotal.toStringAsFixed(2)}"),
          const SizedBox(height: 15),
          _summaryRow("Shipping", "Freeship"),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(color: Color(0xFFEEEEEE)),
          ),
          _summaryRow(
            "Subtotal",
            "\$${subTotal.toStringAsFixed(2)}",
            isTotal: true,
          ),
          const SizedBox(height: 25),
          CustomButton(
            onPressed: subTotal > 0
                ? () {
                    // هنا كود الدفع أو الانتقال لصفحة الـ Checkout
                  }
                : null,
            text: "Proceed to checkout",
            colorButton: AppColors.button,
            height: 60,
            radius: 30,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.black : Colors.grey,
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontSize: isTotal ? 20 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
