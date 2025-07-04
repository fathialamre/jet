/// Product model for DummyJSON API integration example
///
/// This model represents a product from the DummyJSON API
/// (https://dummyjson.com/products)
class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final double weight;
  final ProductDimensions dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<ProductReview> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final ProductMeta meta;
  final List<String> images;
  final String thumbnail;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.meta,
    required this.images,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Unknown Product',
      description: json['description'] as String? ?? 'No description available',
      category: json['category'] as String? ?? 'general',
      price: ((json['price'] as num?) ?? 0).toDouble(),
      discountPercentage: ((json['discountPercentage'] as num?) ?? 0)
          .toDouble(),
      rating: ((json['rating'] as num?) ?? 0).toDouble(),
      stock: json['stock'] as int? ?? 0,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? <String>[],
      brand: json['brand'] as String? ?? 'Unknown Brand',
      sku: json['sku'] as String? ?? 'N/A',
      weight: ((json['weight'] as num?) ?? 0).toDouble(),
      dimensions: json['dimensions'] != null
          ? ProductDimensions.fromJson(
              json['dimensions'] as Map<String, dynamic>,
            )
          : const ProductDimensions(width: 0, height: 0, depth: 0),
      warrantyInformation:
          json['warrantyInformation'] as String? ?? 'No warranty information',
      shippingInformation:
          json['shippingInformation'] as String? ?? 'No shipping information',
      availabilityStatus: json['availabilityStatus'] as String? ?? 'Unknown',
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map(
                (review) =>
                    ProductReview.fromJson(review as Map<String, dynamic>),
              )
              .toList() ??
          <ProductReview>[],
      returnPolicy: json['returnPolicy'] as String? ?? 'No return policy',
      minimumOrderQuantity: json['minimumOrderQuantity'] as int? ?? 1,
      meta: json['meta'] != null
          ? ProductMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : ProductMeta(
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              barcode: 'N/A',
              qrCode: 'N/A',
            ),
      images: (json['images'] as List<dynamic>?)?.cast<String>() ?? <String>[],
      thumbnail:
          json['thumbnail'] as String? ?? 'https://via.placeholder.com/150',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'tags': tags,
      'brand': brand,
      'sku': sku,
      'weight': weight,
      'dimensions': dimensions.toJson(),
      'warrantyInformation': warrantyInformation,
      'shippingInformation': shippingInformation,
      'availabilityStatus': availabilityStatus,
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'returnPolicy': returnPolicy,
      'minimumOrderQuantity': minimumOrderQuantity,
      'meta': meta.toJson(),
      'images': images,
      'thumbnail': thumbnail,
    };
  }

  @override
  String toString() {
    return 'Product(id: $id, title: $title, category: $category, price: \$$price)';
  }
}

class ProductDimensions {
  final double width;
  final double height;
  final double depth;

  const ProductDimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  factory ProductDimensions.fromJson(Map<String, dynamic> json) {
    return ProductDimensions(
      width: ((json['width'] as num?) ?? 0).toDouble(),
      height: ((json['height'] as num?) ?? 0).toDouble(),
      depth: ((json['depth'] as num?) ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'depth': depth,
    };
  }
}

class ProductReview {
  final int rating;
  final String comment;
  final DateTime date;
  final String reviewerName;
  final String reviewerEmail;

  const ProductReview({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      rating: json['rating'] as int? ?? 0,
      comment: json['comment'] as String? ?? 'No comment',
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      reviewerName: json['reviewerName'] as String? ?? 'Anonymous',
      reviewerEmail: json['reviewerEmail'] as String? ?? 'no-email@example.com',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
      'reviewerName': reviewerName,
      'reviewerEmail': reviewerEmail,
    };
  }
}

class ProductMeta {
  final DateTime createdAt;
  final DateTime updatedAt;
  final String barcode;
  final String qrCode;

  const ProductMeta({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  factory ProductMeta.fromJson(Map<String, dynamic> json) {
    return ProductMeta(
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      barcode: json['barcode'] as String? ?? 'N/A',
      qrCode: json['qrCode'] as String? ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'barcode': barcode,
      'qrCode': qrCode,
    };
  }
}
