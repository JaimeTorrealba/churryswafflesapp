import 'package:churrys_waffles/components/commons/order_historic_item.dart';
import 'package:churrys_waffles/providers/orders.dart';
import 'package:churrys_waffles/providers/products.dart';
import '../utils/translations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:collection/collection.dart";

class Report extends StatefulWidget {
  static const String id = '/report';

  const Report({Key? key}) : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context).orders;
    orders.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final groupOrders = orders.toList().groupListsBy((order) {
      return Translations.months[order.createdAt.month]! +
          ' - ' +
          order.createdAt.year.toString();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView(
          children: groupOrders.keys.map(
            (date) {
              final group = groupOrders[date];
              return OrderHistoricItem(date, group!);
            },
          ).toList(),
        ),
      ),
    );
  }
}
