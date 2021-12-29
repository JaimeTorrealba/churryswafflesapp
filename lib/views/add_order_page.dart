import 'package:churrys_waffles/providers/orders.dart';
import 'package:flutter/material.dart';
import '../components/commons/churrys_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../providers/order.dart';
import '../../providers/product.dart';
import 'package:provider/provider.dart';

enum paymentType { E, T }

class AddOrderPage extends StatefulWidget {
  static const String id = '/addOrder';
  @override
  State<AddOrderPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AddOrderPage> {
  Map<String, dynamic> newOrder = {
    'TotalQuantity': 0,
    'TotalPrice': 0,
  };
  int extraQuantity = 0;
  int extraPrice = 0;
  paymentType? paymentFlow = paymentType.E;
  String direction = '';

  List<dynamic> productsData = [];

  final CollectionReference _collectionRefProduct =
      FirebaseFirestore.instance.collection('products');
  final CollectionReference _collectionRefOrders =
      FirebaseFirestore.instance.collection('orders');

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRefProduct.get();

    // Get data from docs and convert map to List
    setState(() {
      productsData = querySnapshot.docs.map((doc) => doc.data()).toList();
      for (var obj in productsData) {
        if (obj != null) {
          obj["Quantity"] = 0;
        }
      }
    });

    print(productsData);
  }

  // void getData() {
  //   productsData = [
  //     {"Name": 'Juan1', "Price": 1000, 'Quantity': 0},
  //     {"Name": 'Juan2', "Price": 2000, 'Quantity': 0},
  //     {"Name": 'Juan3', "Price": 3000, 'Quantity': 0},
  //   ];
  //   print(productsData);
  // }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add new order'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleAddProducts(),
                for (int i = 0; i < productsData.length; i++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        productsData[i]['Name'],
                      ),
                      Text(
                        productsData[i]['Price'].toString(),
                      ),
                      SizedBox(
                        width: 75,
                        child: TextFormField(
                          onChanged: (value) {
                            productsData[i]['Quantity'] =
                                int.tryParse(value) ?? 0;
                            updateNewOrder();
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Cantidad',
                          ),
                        ),
                      ),
                    ],
                  ),
                // Row for Extra
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Extra',
                    ),
                    SizedBox(
                      width: 75,
                      child: TextFormField(
                        onChanged: (value) {
                          extraPrice = int.tryParse(value) ?? 0;
                          updateNewOrder();
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Price',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 75,
                      child: TextFormField(
                        onChanged: (value) {
                          extraQuantity = int.tryParse(value) ?? 0;
                          updateNewOrder();
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Cantidad',
                        ),
                      ),
                    ),
                  ],
                ),
                //Total Row
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ChurrysTitle(titleText: 'Total:'),
                        ChurrysTitle(
                            titleText: newOrder['TotalPrice'].toString()),
                        ChurrysTitle(
                            titleText: newOrder['TotalQuantity'].toString()),
                      ]),
                ),
                TextFormField(
                  onChanged: (value) {
                    direction = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Direcion',
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: RadioListTile<paymentType>(
                        title: const Text('Efectivo'),
                        value: paymentType.E,
                        groupValue: paymentFlow,
                        onChanged: (paymentType? value) {
                          setState(() {
                            paymentFlow = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: RadioListTile<paymentType>(
                        title: const Text('Transferencia'),
                        value: paymentType.T,
                        groupValue: paymentFlow,
                        onChanged: (paymentType? value) {
                          setState(() {
                            paymentFlow = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Center(
                  child: ElevatedButton(
                    //style: style,
                    onPressed: createNewOrder,
                    child: const Text('Create new Order'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void updateNewOrder() {
    List<int> totalQuantityList = [];
    List<int> totalPriceList = [];
    for (dynamic obj in productsData) {
      totalQuantityList.add(obj["Quantity"]);
      totalPriceList.add(obj["Price"] * obj["Quantity"]);
    }

    setState(() {
      //map all orders price sum, quantity sum, if properties
      newOrder["TotalQuantity"] =
          (totalQuantityList.reduce((value, element) => value + element) +
              extraQuantity);
      newOrder["TotalPrice"] =
          totalPriceList.reduce((value, element) => value + element) +
              (extraPrice * extraQuantity);
    });
  }

  void createNewOrder() async {
    List<Product> productsInOrder = [];

    for (dynamic product in productsData) {
      if (product["Quantity"] >= 1) {
        productsInOrder.add(
          Product(
            name: product['Name'],
            price: product['Price'],
            quantity: product['Quantity'],
          ),
        );
      }
    }
    if (extraQuantity >= 1) {
      productsInOrder.add(Product(
        name: 'Extra',
        price: extraPrice,
        quantity: extraQuantity,
      ));
    }
    String paymentTypeConverted = '';
    if (paymentFlow == paymentType.E) {
      paymentTypeConverted = 'E';
    } else {
      paymentTypeConverted = 'T';
    }

    final order = Order(
        id: '',
        price: newOrder["TotalPrice"],
        paymentType: paymentTypeConverted,
        direction: direction,
        quantity: newOrder["TotalQuantity"],
        isPaid: false,
        isDelivered: false,
        products: productsInOrder);

    Provider.of<Orders>(context, listen: false).addOrder(order);
  }
}

class TitleAddProducts extends StatelessWidget {
  const TitleAddProducts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      ChurrysTitle(titleText: 'Product'),
      ChurrysTitle(titleText: 'Price'),
      ChurrysTitle(titleText: 'Quantity')
    ]);
  }
}
