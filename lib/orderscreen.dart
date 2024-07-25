import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final List<String> entries = <String>['6', '7'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
              height: 200,
              child: Center(child: Image.asset("images/image${entries[index]}.jpg")),
            );
            },
            separatorBuilder: (BuildContext context, int index) =>
            const Divider(
              color: Colors.white,
            ),
          )
      ),
    );
  }
}
