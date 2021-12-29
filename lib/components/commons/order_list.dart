import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import '../../providers/order.dart';
import '../../providers/orders.dart';
import './order_item.dart';

class OrderList extends StatefulWidget {
  final List<Order> orders;

  const OrderList({
    Key? key,
    required this.orders,
  }) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.orders
          .map((order) => OrderItem(
                order,
                key: ValueKey(order.id),
              ))
          .toList(),
    );
  }
}
