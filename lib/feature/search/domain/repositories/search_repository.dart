import 'package:gemstore/core/common/entities/product_entity.dart';

abstract class SearchRepository {
  // دالة تبحث في المنتجات بناءً على النص أو التصنيف
  Future<List<ProductEntity>> searchProducts(String query);
}
