import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  String name;
  int price;
  int quantity;

  Product({
    required this.name,
    required this.price,
    required this.quantity,
  });
}
