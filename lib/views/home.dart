import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('products');

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print('se ejecuta el getData');
    print(allData);
  }

  @override
  void initState() {
    print('se ejecuta el initState');
    getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('asd')),
    );
  }
}
