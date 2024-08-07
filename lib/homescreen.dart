import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> entries = <String>['1', '2', '3', '4', '5', '6', '7'];
  final List<String> titles = <String>['JAVANICAN', "What's new", 'MOBILE ORDER', "What's new", '5', '6', '7'];
  final List<String> texts = <String>['ようこそ', 'Daily\nOffering', 'レジに並ばず\nお店で受け取り', '4', '5', '6', '7'];

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
                  child: Stack(

                    fit: StackFit.expand,
                    children: [
                      Container(
                          child: Image.asset(
                            "images/image${entries[index]}.jpg",
                            fit: BoxFit.cover,
                          ),
                      ),
                      Container(
                        child: Column(
                            children: <Widget>[
                              Container(
                                height: 50,
                                child: Text(
                                  titles[index],
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white
                                  ),
                                ),
                                alignment: Alignment.bottomLeft,
                              ),
                              Container(
                                height: 100,
                                child: Text(
                                  texts[index],
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              Container(
                                height: 50,
                                child: Icon(Icons.add_circle_outline,
                                color: Colors.white),
                                alignment: Alignment.centerLeft,
                              )
                        ]
                        ),

                      ),

                    ],
                  )

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
