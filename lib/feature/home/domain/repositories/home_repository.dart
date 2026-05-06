import 'package:gemstore/core/common/entities/product_entity.dart';

abstract class HomeRepository {
  Future<List<ProductEntity>> getAllProducts({Map<String, dynamic>? filters});
}
