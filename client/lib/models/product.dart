class Product {
  final int id;
  final String name;
  final int qty;
  final int categoryId;
  final String imageUrl;
  final DateTime createDate;
  final DateTime updateDate;
  final int createdBy;
  final int updatedBy;

  Product({
    required this.id,
    required this.name,
    required this.qty,
    required this.categoryId,
    required this.imageUrl,
    required this.createDate,
    required this.updateDate,
    required this.createdBy,
    required this.updatedBy,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      qty: json['qty'],
      categoryId: json['category_id'],
      imageUrl: json['image_url'],
      createDate: DateTime.parse(json['create_date']),
      updateDate: DateTime.parse(json['update_date']),
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'qty': qty,
      'category_id': categoryId,
      'image_url': imageUrl,
      'create_date': createDate.toIso8601String(),
      'update_date': updateDate.toIso8601String(),
      'created_by': createdBy,
      'updated_by': updatedBy,
    };
  }
}
