import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> entries = <String>['1', '2', '3', '4', '5', '6', '7'];

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
