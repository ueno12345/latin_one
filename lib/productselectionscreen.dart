import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './productpopupscreen.dart';
class ProductSelectionScreen extends StatefulWidget {
  List<Map<String, dynamic>> cart;
  int id;
  final dynamic shop;
  ProductSelectionScreen({super.key, required this.cart, required this.id, required this.shop});

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  var pieces = '0';

  @override
  Widget build(BuildContext context) {
    // データを取得するための関数
    Future<List<Map<String, dynamic>>> getDocumentData() async {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('shops')
          .doc(widget.shop)
          .collection('products')
          .get();
      List<Map<String, dynamic>> beanList = [];
      for (var bean in snapshot.docs) {
        beanList.add(bean.data() as Map<String, dynamic>);
      }
      return beanList;
    }

    return Scaffold(
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
                return const Text('Error');
              }

              // データが取得できなかったときに表示するWidget
              if (!snapshot.hasData) {
                return const Text('No Data');
              }

              List<Map<String, dynamic>> beanList = snapshot.data!;
              // 取得したデータを表示するWidget
              return Stack(
                children: [
                  Scrollbar(
                    child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: beanList.length,
                        itemBuilder: (context, index) {
                          final bean = beanList[index];
                          return products(bean['imagePath'], bean['productName'], bean['price'], bean['description']);
                        }
                    ),
                  ),
                  _decideButton(),
                ],
              );
            }
        )
    );
  }

  Widget products(image, name, price, description){
    const containerHeight = 180.0;
    const containerWidth = 180.0;
    return Container(
      margin: const EdgeInsets.all(8.0),
      height: containerHeight,
      width: containerWidth,
      child: GestureDetector(
        onTap: () async {
          pieces = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPopupScreen(image: image, product: name.toString(), description: description.toString()),
            )
          );
          (widget.cart).add({'id':widget.id, 'name':name.toString(), 'pieces':pieces.toString(), 'price':price.toString()});
          widget.id++;
        },
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Image.asset(
                //image.toString(),
                "images/image1.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                name.toString(),
                style: const TextStyle(
                    fontSize: 16
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child:
              Row(
                children: [
                  Text(
                    "￥$price",
                    style: const TextStyle(
                      fontSize: 20
                    ),
                  ),
                  const Text(
                    " (100g)",
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                ],
              )
            )
          ],
        ),
      )
    );
  }

  Widget _decideButton() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      alignment: Alignment.bottomCenter,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          minimumSize: const Size(44.0, 44.0),
        ),
        onPressed: () async {
          // カートを返す
          Navigator.pop(context, widget.cart);
          return Future.value();
        },
        child: const Text(
          'OK',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
