import 'package:flutter/material.dart';
class ProductSelectionScreen extends StatefulWidget {
  const ProductSelectionScreen({super.key});

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  static const containerHeight = 120.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ProductSelectionScreen',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        margin: EdgeInsets.all(4.0),
        height: containerHeight,
        alignment: Alignment.center,
        child: Text(
          'Products',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}