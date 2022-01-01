import 'package:churrys_waffles/providers/product.dart';
import 'package:churrys_waffles/views/add_order_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Order with ChangeNotifier {
  String id;
  int price;
  String paymentType;
  String direction;
  int quantity;
  bool isPaid;
  bool isDelivered;
  List<Product> products = [];
  DateTime createdAt;

  Order({
    required this.id,
    required this.price,
    required this.paymentType,
    required this.direction,
    required this.quantity,
    required this.isPaid,
    required this.isDelivered,
    required this.products,
    required this.createdAt,
  });

  static get paymentTypes {
    return {
      'E': 'Efectivo',
      'T': 'Transferencia',
    };
  }
}
