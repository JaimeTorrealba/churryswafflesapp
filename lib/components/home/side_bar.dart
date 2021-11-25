import 'package:churrys_waffles/views/add_order_page.dart';
import 'package:churrys_waffles/views/home.dart';
import 'package:flutter/material.dart';

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
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () => {
            Navigator.of(context).pushNamed(MyHomePage.id),
          },
        ),
        ListTile(
          leading: Icon(Icons.add_shopping_cart),
          title: Text('Add Order'),
          onTap: () => {
            Navigator.of(context).pushNamed(AddOrderPage.id),
          },
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('All Orders'),
          onTap: () => {
            // Navigator.of(context).pushNamed(),
          },
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Report'),
          onTap: () => {
            // Navigator.of(context).pushNamed(),
          },
        ),
      ],
    ));
  }
}
