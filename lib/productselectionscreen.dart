import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './productpopupscreen.dart';
class ProductSelectionScreen extends StatefulWidget {
  List<Map<String, dynamic>> cart;
  int id;
  ProductSelectionScreen({super.key, required this.cart, required this.id});

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  var pieces = '0';

  @override
  Widget build(BuildContext context) {
    // データを取得するための関数
    Future<Map<String, dynamic>> getDocumentData() async {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('shops')
          .doc('javanican')
          .collection('products')
          .doc('beans')
          .collection('categories')
          .doc('blend_coffee')
          .get();
      return snapshot.data() as Map<String, dynamic>;
    }

    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, widget.cart);
          return Future.value(false);
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Products',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.amber,
            ),
            body: FutureBuilder(
                future: getDocumentData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CircularProgressIndicator();
                  }
                  // エラー時に表示するWidget
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Error');
                  }

                  // データが取得できなかったときに表示するWidget
                  if (!snapshot.hasData) {
                    return Text('No Data');
                  }

                  List<MapEntry<String, dynamic>> beanList = snapshot.data!.entries.toList();
                  print(beanList);
                  // 取得したデータを表示するWidget
                  return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                      ),
                      itemCount: beanList.length,
                      itemBuilder: (context, index) {
                        final beanEntry = beanList[index];
                        final bean = beanEntry.value;
                        return products("image8", bean['name'], bean['price'], 100);
                      }
                  );
                }
            )
        )
    );
  }

  Widget products(image, name, price, gram){
    const containerHeight = 180.0;
    const containerWidth = 180.0;
    return Container(
      margin: EdgeInsets.all(8.0),
      height: containerHeight,
      width: containerWidth,
      child: GestureDetector(
        onTap: () async {
            pieces = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPopupScreen(image: image, product: name.toString()),
                )
            );
            (widget.cart).add({'id':widget.id, 'name':name.toString(), 'pieces':pieces.toString(), 'price':price.toString()});
            print(widget.cart);
            widget.id++;
        },
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child:
              Container(
                child: Image.asset(
                  "images/${image}.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child:
              Container(
                child: Text(
                  name.toString(),
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child:
                Row(
                  children: [
                    Container(
                      child: Text(
                        "￥" + price.toString(),
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                    ),
                    Container(

                      child: Text(
                        " (${gram}g)",
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                    )
                  ],
                )

            )
          ],
        ),

      )


    );
  }

  Widget _DecideButton() {
    return Container(
      margin: EdgeInsets.all(4.0),
      alignment: Alignment.bottomCenter,
      child: ElevatedButton(
        child: Text(
          '選択',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
        onPressed: () async {
          // カートを返す
          Navigator.pop(context, widget.cart);
        },
      ),
    );
  }
}