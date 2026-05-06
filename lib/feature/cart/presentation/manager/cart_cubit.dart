import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore/feature/cart/data/repositories/cart_repository.dart';
import 'package:gemstore/feature/cart/presentation/manager/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository repo;
  CartCubit(this.repo) : super(CartInitial());

  // جلب البيانات وحساب الإجمالي
  Future<void> fetchCart() async {
    emit(CartLoading());
    try {
      final data = await repo.getCartItems();
      double total = 0;
      for (var item in data) {
        total += (item['products']['price'] * item['quantity']);
      }
      emit(CartLoaded(items: data, subTotal: total));
    } catch (e) {
      emit(CartError("خطأ في تحميل السلة: $e"));
    }
  }

  // إضافة منتج (تُستدعى من صفحة التفاصيل)
  
  Future<void> addProduct(String productId) async {
    try {
      print("DEBUG: Starting addProduct for ID: $productId");
      
      // تأكدي من انتظار العملية هنا
      await repo.addToCart(productId: productId);
      
      print("DEBUG: Added successfully to Supabase");
      
      // تحديث البيانات محلياً بعد الإضافة الناجحة
      await fetchCart(); 
      
    } catch (e) {
      // هذا السطر سيخبرك بالسبب الحقيقي (مثلاً RLS error أو Database error)
      print("DEBUG: Error adding to cart: $e");
      emit(CartError(e.toString()));
    }
  }

  // تغيير الكمية (تُستدعى من صفحة السلة)
  Future<void> changeQty(int cartId, int newQty) async {
    if (newQty < 1) return;
    try {
      await repo.updateQuantity(cartId, newQty);
      await fetchCart();
    } catch (e) {
      emit(CartError("فشل تحديث الكمية"));
    }
  }
}
