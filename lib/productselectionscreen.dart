import 'dart:math';

import 'package:flutter/material.dart';
import './productpopupscreen.dart';
class ProductSelectionScreen extends StatefulWidget {
  List<Map<String, dynamic>> cart;
  var id;
  ProductSelectionScreen({super.key, required this.cart, required this.id});

  @override
  State<ProductSelectionScreen> createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  static const containerHeight = 120.0;
  var pieces;



  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          products("image8", "ブルーマウンテン", 100, 100),

        ],
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
                  builder: (context) => ProductPopupScreen(image: image, product: name),
                )
            );
            (widget.cart).add({'id':widget.id, 'name':name, 'pieces':pieces, 'price':price});
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
                  "${name}",
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
                        "￥${price}",
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