import 'package:cloud_firestore/cloud_firestore.dart';

/// A product document contains exactly: name, price, soluong, image.
class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.soluong,
    required this.image,
  });

  /// Firestore document ID; it is not stored as a field in the document.
  final String id;
  final String name;
  final num price;
  final int soluong;
  final String image;

  factory ProductModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? <String, dynamic>{};
    return ProductModel(
      id: doc.id,
      name: (data['name'] ?? '').toString(),
      price: data['price'] is num ? data['price'] as num : num.tryParse('${data['price']}') ?? 0,
      soluong: data['soluong'] is num
          ? (data['soluong'] as num).toInt()
          : int.tryParse('${data['soluong']}') ?? 0,
      image: (data['image'] ?? '').toString(),
    );
  }

  /// Keep this map limited to the four fields required by the assignment.
  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
        'soluong': soluong,
        'image': image,
      };
}
