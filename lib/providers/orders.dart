import 'package:churrys_waffles/providers/product.dart';
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

  void setinitListOrder(bool status) {
    _initListOrders = status;
  }

  Future<void> fetchAndSetOrders() async {
    final CollectionReference collectionRefOrders =
        FirebaseFirestore.instance.collection('orders');
    QuerySnapshot querySnapshot = await collectionRefOrders.get();
    final orders = querySnapshot.docs.map((order) {
      final products = (order.get('Products') as List<dynamic>)
          .map((product) => Product(
                name: product['Name'],
                price: product['Price'],
                quantity: product['Quantity'],
              ))
          .toList();
      return Order(
        paymentType: order.get('PaymentType'),
        direction: order.get('Direction'),
        quantity: order.get('Quantity'),
        isPaid: order.get('isPaid'),
        isDelivered: order.get('isDelivered'),
        price: order.get('Price'),
        products: products,
      );
    }).toList();
    _orders = orders;
    notifyListeners();
  }

  Future<void> addOrder(Order newOrder) async {
    final CollectionReference _collectionRefOrders =
        FirebaseFirestore.instance.collection('orders');

    await _collectionRefOrders.add({
      'Price': newOrder.price,
      'Quantity': newOrder.quantity,
      'Direction': newOrder.direction,
      'PaymentType': newOrder.paymentType,
      'Products': newOrder.products.map((product) => {
            'Name': product.name,
            'Price': product.price,
            'Quantity': product.quantity,
          }).toList(),
      'isPaid': false,
      'isDelivered': false
    });
    _orders.add(newOrder);
    notifyListeners();
  }
}
