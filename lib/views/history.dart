import 'package:flutter/material.dart';
import '../components/history/order_list.dart';

class History extends StatefulWidget {
  static const String id = '/history';

  const History({Key? key}) : super(key: key);
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('History'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 25),
                child: Title(
                  color: Colors.black,
                  child: const Text(
                    'Historial de Pedidos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const OrderList(),
            ],
          ),
        ));
  }
}
