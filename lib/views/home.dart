import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/home/side_bar.dart';

class MyHomePage extends StatefulWidget {
  static const String id = '/';
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CollectionReference _collectionRef =
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
  // void initState() {
  //   print('se ejecuta el initState');
  //   getData();
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Churry\'s Waffles App'),
      ),
      drawer: SideBar(),
      // floatingActionButton: ,
    );
  }
}
