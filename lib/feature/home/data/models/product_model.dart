import '../../../../core/common/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.imageUrl,
    super.description,
    super.rating,
    super.reviewsCount,
    super.isFeatured,
  });

  // تحويل الـ JSON القادم من Supabase إلى كائن Model
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] ?? '',
      description: json['description'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviews_count'] ?? 0,
      isFeatured: json['is_featured'] ?? false,
    );
  }
}
