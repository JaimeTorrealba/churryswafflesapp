import 'package:churrys_waffles/providers/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];
  bool _initListproducts = false;

  List<Product> get products {
    return [..._products];
  }

  bool get initListproducts {
    return _initListproducts;
  }

  void setinitListproduct(bool status) {
    _initListproducts = status;
  }

  Future<void> fetchAndSetProducts() async {
    final CollectionReference collectionRefOrders =
        FirebaseFirestore.instance.collection('products');
    QuerySnapshot querySnapshot = await collectionRefOrders.get();
    final products = querySnapshot.docs.map((product) {
      return Product(
        name: product.get('Name'),
        price: product.get('Price'),
        quantity: product.get('Price'),
      );
    }).toList();
    _products = products;
    notifyListeners();
  }
}
