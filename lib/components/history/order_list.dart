import 'package:flutter/material.dart';
import '../../providers/order.dart';
import 'package:intl/intl.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final orders = <Order>[
    Order(
        price: 1000,
        paymentType: 'T',
        direction: 'Avenida Quilin',
        quantity: 4000,
        isPaid: false,
        isDelivered: false)
  ];

  static const Map<bool, String> boolTranstalation = {
    true:  'Si',
    false: 'No',
  };

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
              DataColumn(label: Text('N Art.°')),
              DataColumn(label: Text('Total.')),
              DataColumn(label: Text('Tipo Pago')),
              DataColumn(label: Text('Pago')),
              DataColumn(label: Text('Entregado')),
              DataColumn(label: Text('Dirección')),
              DataColumn(label: Text('')),
            ],
            rows: orders.map((order) {
              return DataRow(cells: <DataCell>[
                  DataCell(Text(order.quantity.toString())),
                  DataCell(Text(order.price.toString())),
                  DataCell(Text(order.paymentType)),
                  DataCell(Text('${boolTranstalation[order.isPaid]}')),
                  DataCell(Text('${boolTranstalation[order.isDelivered]}')),
                  DataCell(Text(order.direction)),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () => {},
                    ),
                  ),
              ]);
            }).toList()));
  }
}
