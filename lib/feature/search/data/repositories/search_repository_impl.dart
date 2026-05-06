import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gemstore/core/common/entities/product_entity.dart';
import 'package:gemstore/feature/home/data/models/product_model.dart'; // استخدمي موديل المنتجات الموجود عندك
import '../../domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final _supabase = Supabase.instance.client;

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    try {
      // البحث في عمود 'name' عن أي نص يحتوي على الكلمة المكتوبة
      final response = await _supabase
          .from('products')
          .select()
          .ilike('name', '%$query%'); // % تعني أي نص قبل أو بعد الكلمة

      return (response as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception("Search failed: $e");
    }
  }
}
