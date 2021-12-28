import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/order.dart';
import '../../providers/orders.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> with WidgetsBindingObserver {
  static const Map<bool, String> boolTranstalation = {
    true: 'Si',
    false: 'No',
  };

  @override
  void didChangeDependencies() {
    final orders = Provider.of<Orders>(context);
    if (!orders.initListOrders) {
      orders.fetchAndSetOrders();
      orders.setinitListOrder(true);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context).orders;
    return Container(
      margin: const EdgeInsets.only(top: 0),
      padding: const EdgeInsets.all(10),
      child: DataTable(
        dataRowColor:
            MaterialStateColor.resolveWith((states) => Colors.grey.shade50),
        dataRowHeight: 60,
        columnSpacing: 20,
        columns: const <DataColumn>[
          DataColumn(
            label: Text('N°'),
          ),
          DataColumn(
            label: Text('Total.'),
          ),
          DataColumn(
            label: Text('Tipo'),
          ),
          DataColumn(
            label: Text('Pago'),
          ),
          DataColumn(
            label: Text('Entre.'),
          ),
          DataColumn(
            label: Text('Dir.'),
          ),
          DataColumn(
            label: Text(''),
          ),
        ],
        rows: orders.map(
          (order) {
            return DataRow(
              cells: <DataCell>[
                DataCell(
                  Text(
                    order.quantity.toString(),
                  ),
                ),
                DataCell(
                  Text(
                    order.price.toString(),
                  ),
                ),
                DataCell(
                  Text(order.paymentType),
                ),
                DataCell(
                  Text('${boolTranstalation[order.isPaid]}'),
                ),
                DataCell(
                  Text('${boolTranstalation[order.isDelivered]}'),
                ),
                DataCell(
                  Text(order.direction),
                ),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () => {},
                  ),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}
