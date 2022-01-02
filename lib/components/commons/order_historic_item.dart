import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "package:collection/collection.dart";
import 'package:provider/provider.dart';

import 'package:churrys_waffles/providers/order.dart';
import '../../providers/orders.dart';

class OrderHistoricItem extends StatefulWidget {
  final String title;
  final List<Order> orders;

  const OrderHistoricItem(this.title, this.orders, {Key? key})
      : super(key: key);

  @override
  State<OrderHistoricItem> createState() => _OrderHistoricItemState();
}

class _OrderHistoricItemState extends State<OrderHistoricItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final ordersByDay = widget.orders.toList().groupListsBy((order) {
      return widget.title + ' - ' + order.createdAt.day.toString();
    });
    var statsByDay = {};
    ordersByDay.forEach((day, orders) {
      statsByDay[day] = {
        "day": day.toString().split(" - ").last,
        "profit": orders.map((order) => order.price).sum,
        "quantity": orders.length,
        "cash": orders.where((order) => order.paymentType == 'E').length,
        "trans": orders.where((order) => order.paymentType == 'T').length,
      };
    });

    final profitTotal =
        widget.orders.map((order) => order.price).sum.toString();
    final quantityTotal = widget.orders.length.toString();
    final cashTotal = widget.orders
        .where((order) => order.paymentType == 'E')
        .length
        .toString();
    final transTotal = widget.orders
        .where((order) => order.paymentType == 'T')
        .length
        .toString();
    const totalTextStyle = TextStyle(fontWeight: FontWeight.bold);

    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            leading: const Icon(Icons.receipt_long_outlined),
            title: Text(
              widget.title,
              style: const TextStyle(fontSize: 18),
            ),
            trailing: Icon(
              _expanded ? Icons.expand_less : Icons.expand_more,
            ),
          ),
          if (_expanded)
            DataTable(
              columnSpacing: 35,
              columns: const [
                DataColumn(
                  label: Text(
                    'Día',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Ganan.',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Cant',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Efec.',
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Trans.',
                  ),
                ),
              ],
              rows: statsByDay.keys.map(
                    (day) {
                      return DataRow(
                        cells: [
                          DataCell(Text(statsByDay[day]["day"])),
                          DataCell(Text(statsByDay[day]["profit"].toString())),
                          DataCell(
                              Text(statsByDay[day]["quantity"].toString())),
                          DataCell(Text(statsByDay[day]["cash"].toString())),
                          DataCell(Text(statsByDay[day]["trans"].toString())),
                        ],
                      );
                    },
                  ).toList() +
                  [
                    DataRow(
                      cells: [
                        const DataCell(Text('')),
                        DataCell(
                          Text(
                            profitTotal,
                            style: totalTextStyle,
                          ),
                        ),
                        DataCell(
                          Text(
                            quantityTotal,
                            style: totalTextStyle,
                          ),
                        ),
                        DataCell(
                          Text(
                            cashTotal,
                            style: totalTextStyle,
                          ),
                        ),
                        DataCell(
                          Text(
                            transTotal,
                            style: totalTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
            )
        ],
      ),
    );
  }
}
