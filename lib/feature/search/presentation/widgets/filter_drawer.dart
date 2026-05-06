import 'package:flutter/material.dart';
import 'package:gemstore/core/widgets/shared_screens/products_result_screen.dart';

class FilterDrawer extends StatefulWidget {
  const FilterDrawer({super.key});

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  // --- متغيرات الحالة (State) ---
  RangeValues _priceRange = const RangeValues(10, 80);
  Color? _selectedColor;
  int _selectedRating = 5;
  String _selectedCategory = "Dress"; // القيمة الافتراضية

  // البيانات الثابتة
  final List<Color> _availableColors = [
    Colors.orange,
    Colors.red,
    const Color(0xFF1A2433),
    Colors.blueGrey,
    Colors.grey.shade200,
    Colors.brown,
  ];

  final List<String> _categories = [
    "Clothes",
    "Shoes",
    "Accessories",
    "Crop Tops",
    "Dress",
  ];
  final List<String> _discounts = ["50% off", "40% off", "30% off", "25% off"];
  String _selectedDiscount = "50% off";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // --- Header Section ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Filter",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- Body Section ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price Range
                    const Text(
                      "Price",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    RangeSlider(
                      values: _priceRange,
                      max: 100,
                      activeColor: Colors.black,
                      inactiveColor: Colors.grey.shade200,
                      onChanged: (values) =>
                          setState(() => _priceRange = values),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${_priceRange.start.round()}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "\$${_priceRange.end.round()}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Color Selection
                    const Text(
                      "Color",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _availableColors.map((color) {
                        bool isSelected = _selectedColor == color;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = color),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: Colors.black, width: 2)
                                  : null,
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30),

                    // Star Rating
                    const Text(
                      "Star Rating",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (index) {
                        int val = index + 1;
                        bool isSel = _selectedRating == val;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedRating = val),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: isSel
                                  ? const Color(0xFF333333)
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 14,
                                  color: isSel ? Colors.white : Colors.black,
                                ),
                                Text(
                                  " $val",
                                  style: TextStyle(
                                    color: isSel ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 30),

                    // Category Dropdown
                    const Text(
                      "Category",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: _categories
                              .map(
                                (String val) => DropdownMenuItem(
                                  value: val,
                                  child: Text(val),
                                ),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedCategory = v!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Discount Wrap
                    const Text(
                      "Discount",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _discounts.map((d) {
                        bool isSel = _selectedDiscount == d;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedDiscount = d),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSel ? Colors.black : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSel
                                    ? Colors.black
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  d,
                                  style: TextStyle(
                                    color: isSel ? Colors.white : Colors.black,
                                  ),
                                ),
                                if (isSel)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // --- Bottom Buttons Section ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => setState(() {
                        _selectedColor = null;
                        _selectedCategory = "Dress";
                        _priceRange = const RangeValues(10, 80);
                      }),
                      child: const Text(
                        "Reset",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF333333),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        // 2. إغلاق الـ Drawer
                        Navigator.pop(context);

                        // 4. الانتقال لصفحة النتائج (بدون تمرير لستة فارغة)
                        // يفضل أن تستخدم صفحة النتائج الـ BlocBuilder لعرض البيانات القادمة من الكيوبيت
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductsResultScreen(
                              subCategory: _selectedCategory,
                              // هنا نجعل الصفحة هي التي تراقب الـ Cubit
                              // سيتم تحديثها عبر الـ BlocBuilder داخل الصفحة
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Apply",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
