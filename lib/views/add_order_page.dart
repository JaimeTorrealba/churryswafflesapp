import 'package:flutter/material.dart';

class AddOrderPage extends StatefulWidget {
  @override
  State<AddOrderPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AddOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New order page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/'
                      // arguments:'A argument'
                      );
                },
                child: const Text('Go home'))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
