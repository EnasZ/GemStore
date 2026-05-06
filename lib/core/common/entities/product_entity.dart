class ProductEntity {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String? description;
  final double rating;
  final int reviewsCount;
  final bool isFeatured;

  ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.description,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.isFeatured = false,
  });
}
