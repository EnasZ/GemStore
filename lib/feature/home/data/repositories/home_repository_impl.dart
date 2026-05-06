import 'package:gemstore/core/common/entities/product_entity.dart';
import 'package:gemstore/feature/home/data/models/product_model.dart';
import 'package:gemstore/feature/home/domain/repositories/home_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeRepositoryImpl implements HomeRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<List<ProductEntity>> getAllProducts({
    Map<String, dynamic>? filters,
  }) async {
    try {
      var query = _supabase.from('products').select();

      if (filters != null && filters.isNotEmpty) {
        filters.forEach((key, value) {
          if (value != null) {
            // إذا كان المفتاح هو 'name'، نستخدم ilike للبحث الجزئي
            if (key == 'name') {
              // % تعني ابحث عن الكلمة في أي مكان (قبلها أو بعدها نص)
              query = query.ilike('name', '%$value%');
            } else {
              // لبقية الفلاتر (مثل الفئة أو اللون) نستخدم التطابق التام
              query = query.eq(key, value);
            }
          }
        });
      }

      final response = await query;

      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception("حدث خطأ في سوبابيس: $e");
    }
  }
}
