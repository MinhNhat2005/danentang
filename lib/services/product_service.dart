import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  ProductService._();
  static final instance = ProductService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _products =>
      _db.collection('products');

  Stream<List<ProductModel>> watchProducts() => _products
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map(ProductModel.fromDocument)
          .toList());

  Future<void> addProduct({
    required String name,
    required num price,
    required int soluong,
    required String image,
  }) async {
    await _products.add({
      'name': name.trim(),
      'price': price,
      'soluong': soluong,
      'image': image,
    });
  }

  Future<void> updateProduct({
    required String id,
    required String name,
    required num price,
    required int soluong,
    required String image,
  }) async {
    await _products.doc(id).update({
      'name': name.trim(),
      'price': price,
      'soluong': soluong,
      'image': image,
    });
  }

  Future<void> deleteProduct(String id) => _products.doc(id).delete();
}
