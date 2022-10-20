class Product {
  var id;
  final String name;
  var category;
  final String getAbsoluteUrl;
  final String description;
  final String price;
  final String getImage;
  final String getThumbnail;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.getAbsoluteUrl,
    required this.description,
    required this.price,
    required this.getImage,
    required this.getThumbnail,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      "name": name,
      "category": category,
      "getAbsoluteUrl": getAbsoluteUrl,
      "description": description,
      "price": price,
      "getImage": getImage,
      "getThumbnail": getThumbnail
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      getAbsoluteUrl: map['getAbsoluteUrl'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? '',
      getImage: map['getImage'] ?? '',
      getThumbnail: map['getThumbnail'] ?? '',
    );
  }
}
