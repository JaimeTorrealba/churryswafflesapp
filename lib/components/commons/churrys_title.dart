import 'package:flutter/material.dart';

class ChurrysTitle extends StatelessWidget {
  ChurrysTitle({required this.titleText});

  String titleText;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$titleText',
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
    );
  }
}
