import 'package:flutter/material.dart';
import '../components/commons/churrysTitle.dart';

class AddOrderPage extends StatefulWidget {
  static const String id = '/addOrder';
  @override
  State<AddOrderPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AddOrderPage> {
  List<Widget> cheader = [
    Text(
      'asdsad',
    ),
    Text(
      '23232 \$',
    ),
    Text(
      '4',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new order'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ChurrysTitle(titleText: 'Product'),
            ChurrysTitle(titleText: 'Price'),
            ChurrysTitle(titleText: 'Quantity')
          ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: cheader),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ChurrysTitle(titleText: 'Total:'),
          ])
        ]),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
