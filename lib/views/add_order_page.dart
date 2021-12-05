import 'package:flutter/material.dart';
import '../components/commons/churrys_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const initialQuantity = {'quantity': 0};

class AddOrderPage extends StatefulWidget {
  static const String id = '/addOrder';
  @override
  State<AddOrderPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AddOrderPage> {
  Map<String, dynamic> newOrder = {
    'totalQuantity': 0,
    'totalPrice': 0,
  };
  int totalQuantity = 0;
  late dynamic productsData;

  // final CollectionReference _collectionRef =
  //     FirebaseFirestore.instance.collection('products');
  //
  // Future<void> getData() async {
  //   // Get docs from collection reference
  //   QuerySnapshot querySnapshot = await _collectionRef.get();
  //
  //   // Get data from docs and convert map to List
  //   productsData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //   for (var obj in productsData) {
  //     obj["quantity"] = 0;
  //   }
  //   print(productsData);
  // }

  void getData() {
    productsData = [
      {"Name": 'Juan1', "Price": 1000, 'Quantity': 0},
      {"Name": 'Juan2', "Price": 2000, 'Quantity': 0},
      {"Name": 'Juan3', "Price": 3000, 'Quantity': 0},
    ];
    print(productsData);
  }

  @override
  void initState() {
    getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add new order'),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleAddProducts(),
              for (int i = 0; i < productsData.length; i++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          productsData[i]['Quantity'] = value;
                          updateNewOrder(i, value);
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text('Total:'),
                Text(newOrder['totalQuantity'].toString())
              ])
            ],
          ),
        ));
  }

  dynamic updateNewOrder(key, value) {
    setState(() {
      newOrder['totalQuantity'] = newOrder['totalQuantity'] + int.parse(value);
    });

    print(productsData[key]);
    print(newOrder['totalQuantity']);
    print(value);
  }
}

class TitleAddProducts extends StatelessWidget {
  const TitleAddProducts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ChurrysTitle(titleText: 'Product'),
      ChurrysTitle(titleText: 'Price'),
      ChurrysTitle(titleText: 'Quantity')
    ]);
  }
}
