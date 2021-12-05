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
    'TotalQuantity': 0,
    'TotalPrice': 0,
  };
  int totalQuantity = 0;
  late List<Map<String, dynamic>> productsData;

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
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Text('Total:'),
                Text(newOrder['TotalPrice'].toString()),
                Text(newOrder['TotalQuantity'].toString()),
              ])
            ],
          ),
        ));
  }

  void updateNewOrder() {
    List<int> totalQuantityList = [];
    List<int> totalPriceList = [];
    for (var obj in productsData) {
      totalQuantityList.add(obj["Quantity"]);
      totalPriceList.add(obj["Price"] * obj["Quantity"]);
    }
    setState(() {
      //map all orders price sum, quantity sum, if properties
      newOrder["TotalQuantity"] =
          totalQuantityList.reduce((value, element) => value + element);
      newOrder["TotalPrice"] =
          totalPriceList.reduce((value, element) => value + element);
    });
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
