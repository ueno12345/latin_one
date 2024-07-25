import 'package:flutter/material.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
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
