import 'package:flutter/foundation.dart';

class Order with ChangeNotifier {
  int price;
  String paymentType;
  String direction;
  int quantity;
  bool isPaid;
  bool isDelivered;

  Order({
    required this.price,
    required this.paymentType,
    required this.direction,
    required this.quantity,
    required this.isPaid,
    required this.isDelivered,
  });
}
