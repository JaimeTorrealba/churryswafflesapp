import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import './order.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];
  bool _initListOrders = false;

  List<Order> get orders {
    return [..._orders];
  }

  bool get initListOrders {
    return _initListOrders;
  }

  void setinitListOrder (bool status) {
    _initListOrders = status;
  }

  Future<void> fetchAndSetProducts() async {
    final CollectionReference collectionRefOrders =
        FirebaseFirestore.instance.collection('orders');
    QuerySnapshot querySnapshot = await collectionRefOrders.get();
    final orders = querySnapshot.docs.map((order) {
      return Order(
        paymentType: order.get('PaymentType'),
        direction: order.get('Direction'),
        quantity: order.get('Quantity'),
        isPaid: order.get('isPaid'),
        isDelivered: order.get('isDelivered'),
        price: order.get('Price'),
      );
    }).toList();
    _orders = orders;
    notifyListeners();
  }

  //   Future<void> addProduct(Product product) async {
  //   final response = await http.post(
  //     Uri.parse(
  //         'https://sho-app-c8eb6-default-rtdb.firebaseio.com/products.json'),
  //     body: json.encode(
  //       {
  //         'title': product.title,
  //         'description': product.description,
  //         'imageUrl': product.imageUrl,
  //         'price': product.price,
  //         'isFavorite': product.isFavorite,
  //       },
  //     ),
  //   );

  //   final newProduct = Product(
  //     title: product.title,
  //     description: product.description,
  //     price: product.price,
  //     imageUrl: product.imageUrl,
  //     id: json.decode(response.body)['name'],
  //   );
  //   _items.add(newProduct);
  //   notifyListeners();
  // }
}
