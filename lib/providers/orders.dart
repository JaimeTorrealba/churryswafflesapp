import 'package:churrys_waffles/providers/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import './order.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];
  bool _initListOrders = false;
  bool _initListHistoryOrders = false;
  Map<String, dynamic> _filter = {};

  List<Order> get orders {
    return [..._orders];
  }

  bool get initListOrders {
    return _initListOrders;
  }

  void setinitListOrder(bool status) {
    _initListOrders = status;
  }

  bool get initListHistoryOrders {
    return _initListHistoryOrders;
  }

  void setinitListHistoryOrders(bool status) {
    _initListHistoryOrders = status;
  }

  Map<String, dynamic> get filters {
    return _filter;
  }

  void setFilters(Map<String, dynamic> filters) {
    _filter = filters;
  }

  List<Order> get newOrders {
    final orders = _orders.where(
      (order) {
        return (!order.isDelivered && !order.isPaid);
      },
    ).toList();
    orders.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return orders;
  }

  List<Order> get paidOrders {
    final orders = _orders.where((order) {
      return (!order.isDelivered && order.isPaid);
    }).toList();
    orders.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return orders;
  }

  List<Order> get deliveredOrders {
    final orders = _orders.where((order) {
      return (order.isDelivered && order.isPaid);
    }).toList();
    orders.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return orders;
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
      createdAt: existingProduct.createdAt,
      isDelivered: isDelivered,
      isPaid: isPaid,
    );
    setinitListHistoryOrders(false);
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
        createdAt: DateTime.parse(order.get('CreatedAt').toDate().toString()),
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
      'isDelivered': false,
      'CreatedAt': newOrder.createdAt,
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
