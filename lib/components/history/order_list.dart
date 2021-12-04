import 'package:flutter/material.dart';
import '../../models/order.dart';
import 'package:intl/intl.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final orders = <Order>[
    Order(
        itemNumber: 1,
        order: 1,
        time: DateTime.now(),
        total: 4000,
        payment: 'E',
        direction: 'Avenida Quilín 4931'),
    Order(
        itemNumber: 2,
        order: 2,
        time: DateTime.now(),
        total: 5000,
        payment: 'E',
        direction: 'Avenida Macul 2828'),
    Order(
        itemNumber: 4,
        order: 3,
        time: DateTime.now(),
        total: 5000,
        payment: 'E',
        direction: 'Avenida Macul 2828'),
    Order(
        itemNumber: 2,
        order: 4,
        time: DateTime.now(),
        total: 5000,
        payment: 'E',
        direction: 'Avenida Macul 2828'),
    Order(
        itemNumber: 2,
        order: 5,
        time: DateTime.now(),
        total: 5000,
        payment: 'E',
        direction: 'Avenida Macul 2828'),
    Order(
        itemNumber: 2,
        order: 6,
        time: DateTime.now(),
        total: 5000,
        payment: 'E',
        direction: 'Avenida Macul 2828'),
    Order(
        itemNumber: 2,
        order: 7,
        time: DateTime.now(),
        total: 5000,
        payment: 'E',
        direction: 'Avenida Macul 2828'),
    Order(
        itemNumber: 2,
        order: 8,
        time: DateTime.now(),
        total: 5000,
        payment: 'E',
        direction: 'Avenida Macul 2828'),
    Order(
        itemNumber: 2,
        order: 8,
        time: DateTime.now(),
        total: 5000,
        payment: 'E',
        direction: 'Avenida Macul 2828'),
    Order(
        itemNumber: 2,
        order: 8,
        time: DateTime.now(),
        total: 5000,
        payment: 'E',
        direction: 'Avenida Macul 2828'),
    Order(
        itemNumber: 2,
        order: 8,
        time: DateTime.now(),
        total: 5000,
        payment: 'E',
        direction: 'Avenida Macul 2828'),
    Order(
        itemNumber: 2,
        order: 8,
        time: DateTime.now(),
        total: 5000,
        payment: 'E',
        direction: 'Avenida Macul 2828'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 0),
        padding: const EdgeInsets.all(10),
        child: DataTable(
            // headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade100),
            dataRowColor:
                MaterialStateColor.resolveWith((states) => Colors.grey.shade50),
            dataRowHeight: 60,
            columnSpacing: 20,
            columns: const <DataColumn>[
              DataColumn(label: Text('N°')),
              DataColumn(label: Text('Ord.')),
              DataColumn(label: Text('Hora')),
              DataColumn(label: Text('Total')),
              DataColumn(label: Text('Pago')),
              DataColumn(label: Text('Dirección')),
            ],
            rows: orders.map((order) {
              return DataRow(cells: <DataCell>[
                DataCell(Text(order.itemNumber.toString())),
                DataCell(Text(order.order.toString())),
                DataCell(Text(DateFormat('h:mm').format(order.time))),
                DataCell(Text(order.total.toString())),
                DataCell(Text(order.payment)),
                DataCell(Text(order.direction)),
              ]);
            }).toList()));
  }
}
