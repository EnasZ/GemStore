part of 'product_cubit.dart';

abstract class ProductState {}

// 1. الحالة الابتدائية عند فتح التطبيق لأول مرة
class ProductInitial extends ProductState {}

// 2. حالة التحميل (تُظهر مؤشر الانتظار CircularProgressIndicator)
class ProductLoading extends ProductState {}

// 3. حالة النجاح (تحتوي على قائمة المنتجات القادمة من Supabase)
class ProductLoaded extends ProductState {
  final List<ProductEntity> products;

  ProductLoaded({required this.products});
}

// 4. حالة "لا توجد بيانات" (تُستخدم عند فلترة تصنيف لا يحتوي على منتجات)
class ProductEmpty extends ProductState {}

// 5. حالة الخطأ (تحتوي على رسالة الخطأ لعرضها للمستخدم)
class ProductError extends ProductState {
  final String message;

  ProductError({required this.message});
}
