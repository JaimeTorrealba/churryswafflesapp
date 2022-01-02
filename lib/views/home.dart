import 'package:churrys_waffles/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../components/home/side_bar.dart';
import '../views/add_order_page.dart';
import '../components/commons/order_list.dart';
import '../providers/orders.dart';

class MyHomePage extends StatefulWidget {
  static const String id = '/';
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void didChangeDependencies() {
    final orders = Provider.of<Orders>(context);
    final products = Provider.of<Products>(context);
    if (!orders.initListOrders) {
      orders.fetchAndSetOrders();
      orders.setinitListOrder(true);
    }
    if (!products.initListproducts) {
      products.fetchAndSetProducts();
      products.setinitListproduct(true);
    }
    super.didChangeDependencies();
  }

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
              Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 25),
                  child: Title(
                    color: Colors.black,
                    child: const Text(
                      'Pedidos Nuevos - Confirmación de Pago',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
              OrderList(
                orders: Provider.of<Orders>(context).newOrders,
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Title(
                    color: Colors.black,
                    child: const Text(
                      'Pedidos - Esperando Entrega',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),
              OrderList(
                orders: Provider.of<Orders>(context).paidOrders,
              )
            ],
          ),
        ));
  }
}
