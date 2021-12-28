import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../components/home/side_bar.dart';
import '../views/add_order_page.dart';
import '../components/home/order_list.dart';
import '../providers/orders.dart';

class MyHomePage extends StatefulWidget {
  static const String id = '/';
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final CollectionReference _collectionRef =
  //     FirebaseFirestore.instance.collection('products');

  // Future<void> getData() async {
  //   // Get docs from collection reference
  //   QuerySnapshot querySnapshot = await _collectionRef.get();
  //
  //   // Get data from docs and convert map to List
  //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //   print('se ejecuta el getData');
  //   print(allData);
  // }

  // @override
  // void initState() {
  //   // Provider.of<Orders>(context).fetchAndSetProducts;
  //   super.initState();
  // }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Churry\'s Waffles App'),
        ),
        drawer: SideBar(),
         floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AddOrderPage.id);
        },
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
                    'Pedidos Nuevos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const OrderList(),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: Title(
                  color: Colors.black,
                  child: const Text(
                    'Esperando Confirmación de Pago',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const OrderList()
            ],
          ),
        ));
  }
}
