import 'package:flutter/material.dart';

class ItemCart extends StatelessWidget {
  final String title;
  final String price;
  final String sizeColor;
  final String imageUrl;
  final int quantity;
  final bool isSelected;
  final VoidCallback? onAdd;
  final VoidCallback? onRemove;
  final VoidCallback? onToggleSelect;

  const ItemCart({
    super.key,
    required this.title,
    required this.price,
    required this.sizeColor,
    required this.imageUrl,
    this.quantity = 1,
    this.isSelected = true,
    this.onAdd,
    this.onRemove,
    this.onToggleSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. صورة المنتج
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(20),
            ),
            child: Image.network(
              imageUrl,
              width: 100,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),

          // 2. تفاصيل المنتج
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    sizeColor,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          // 3. التحكم في الكمية واختيار المنتج
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // زرار الاختيار (Check Box)
                GestureDetector(
                  onTap: onToggleSelect,
                  child: Icon(
                    isSelected
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: isSelected ? const Color(0xFF5D8E7B) : Colors.grey,
                  ),
                ),

                // زرار الزيادة والنقصان
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      _buildQtyBtn(Icons.remove, onRemove),
                      Text(
                        " $quantity ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      _buildQtyBtn(Icons.add, onAdd),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(icon, size: 16, color: Colors.black),
      ),
    );
  }
}
