import 'package:supabase_flutter/supabase_flutter.dart';

class CartRepository {
  final _supabase = Supabase.instance.client;

  // 1. جلب محتويات السلة مع بيانات المنتجات (Join)
  Future<List<Map<String, dynamic>>> getCartItems() async {
  final userId = _supabase.auth.currentUser!.id;
  
  // هنا نطلب كل أعمدة السلة + تفاصيل المنتج المرتبط
  final response = await _supabase
      .from('cart')
      .select('''
        id, 
        quantity,
        product_id,
        products:product_id (*) 
      ''') 
      .eq('user_id', userId);
      
  return response;
}

  // 2. إضافة منتج للسلة (أو زيادة الكمية إذا كان موجوداً)
 Future<void> addToCart({required String productId, int quantity = 1}) async {
  try {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      print("خطأ: لا يوجد مستخدم مسجل دخول!");
      return;
    }
    
    final userId = user.id;
    print("محاولة إضافة منتج $productId للمستخدم $userId");

    final existingItem = await _supabase
        .from('cart')
        .select()
        .eq('user_id', userId)
        .eq('product_id', productId)
        .maybeSingle();

    if (existingItem != null) {
      print("المنتج موجود، يتم تحديث الكمية...");
      await _supabase
          .from('cart')
          .update({'quantity': existingItem['quantity'] + quantity})
          .eq('id', existingItem['id']);
    } else {
      print("منتج جديد، يتم الإضافة الآن...");
      await _supabase.from('cart').insert({
        'user_id': userId,
        'product_id': productId,
        'quantity': quantity,
      });
    }
    print("تمت العملية بنجاح في Supabase!");
  } catch (e) {
    print("فشل الاتصال بـ Supabase: $e"); // هذا سيطبع لكِ السبب الحقيقي (مثل إذن ممنوع أو خطأ في النوع)
  }
}
  // 3. تحديث الكمية (للأزرار + و - داخل السلة)
  Future<void> updateQuantity(int cartId, int newQty) async {
    await _supabase.from('cart').update({'quantity': newQty}).eq('id', cartId);
  }

  // 4. حذف منتج نهائياً
  Future<void> removeFromCart(int cartId) async {
    await _supabase.from('cart').delete().eq('id', cartId);
  }
}
