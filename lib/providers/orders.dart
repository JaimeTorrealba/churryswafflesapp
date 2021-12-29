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

  List<Order> get newOrders {
    return _orders.where(
      (order) {
        return (!order.isDelivered && !order.isPaid);
      },
    ).toList();
  }

  List<Order> get paidOrders {
    return _orders.where((order) {
      return (!order.isDelivered && order.isPaid);
    }).toList();
  }

  List<Order> get deliveredOrders {
    return _orders.where((order) {
      return (order.isDelivered && order.isPaid);
    }).toList();
  }

  Future<void> setStatusOrder(
      String orderId, bool isDelivered, bool isPaid) async {
    final CollectionReference _collectionRefOrders =
        FirebaseFirestore.instance.collection('orders');
    await _collectionRefOrders
        .doc(orderId)
        .update({'isDelivered': isDelivered, 'isPaid': isPaid});
    final existingProductIndex =
        _orders.indexWhere((order) => order.id == orderId);
    final existingProduct = _orders[existingProductIndex];
    _orders[existingProductIndex] = Order(
      id: existingProduct.id,
      price: existingProduct.price,
      paymentType: existingProduct.paymentType,
      direction: existingProduct.direction,
      quantity: existingProduct.quantity,
      products: existingProduct.products,
      isDelivered: isDelivered,
      isPaid: isPaid,
    );
    notifyListeners();
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
        id: order.reference.id,
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
      'Products': newOrder.products
          .map((product) => {
                'Name': product.name,
                'Price': product.price,
                'Quantity': product.quantity,
              })
          .toList(),
      'isPaid': false,
      'isDelivered': false
    }).then((doc) {
      newOrder.id = doc.id;
    });
    _orders.add(newOrder);
    notifyListeners();
  }

  Future<void> deleteOrder(Order deletedOrder) async {
    final CollectionReference _collectionRefOrders =
        FirebaseFirestore.instance.collection('orders');
    await _collectionRefOrders.doc(deletedOrder.id).delete();
    final existingProductIndex =
        _orders.indexWhere((order) => order.id == deletedOrder.id);
    _orders.removeAt(existingProductIndex);
    notifyListeners();
  }
}
