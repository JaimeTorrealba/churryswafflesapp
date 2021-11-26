import 'package:flutter/material.dart';

class History extends StatefulWidget {
  static const String id = '/history';

  const History({Key? key}) : super(key: key);
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  final orders = [
    {
        "name": "wafle 1",
        "direction": "avenida mata",
        "date": "01/01/2021",
        "paid_type": "transferencia"
    },
    {
        "name": "wafle 2",
        "direction": "avenida quilin",
        "date": "01/01/2021",
        "paid_type": "efectivo"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...(orders).map((order) {
              return Text(order['name'] as String);
            }).toList()
          ],
        ),
      ),
    );
  }
}
