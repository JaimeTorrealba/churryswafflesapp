import 'package:churrys_waffles/providers/orders.dart';
import 'package:churrys_waffles/views/add_order_page.dart';
import 'package:churrys_waffles/views/history.dart';
import 'package:churrys_waffles/views/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        const DrawerHeader(
          child: Center(
            child: Text('Menu'),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () => {
            Navigator.of(context).pushNamed(MyHomePage.id),
          },
        ),
        ListTile(
          leading: const Icon(Icons.add_shopping_cart),
          title: const Text('Add Order'),
          onTap: () => {
            Navigator.of(context).pushNamed(AddOrderPage.id),
          },
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('History'),
          onTap: () => {
            Provider.of<Orders>(context, listen: false).setFilters({}),
            Provider.of<Orders>(context, listen: false)
                .setinitListHistoryOrders(false),
            Navigator.of(context).pushNamed(History.id)
          },
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Report'),
          onTap: () => {
            // Navigator.of(context).pushNamed(),
          },
        ),
      ],
    ));
  }
}
