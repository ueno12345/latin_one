import 'package:flutter/material.dart';
import './shopselectionscreen.dart';
import './productselectionscreen.dart';
import './purchasedetailscreen.dart';
//import 'dart:async';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  static const containerHeight = 120.0;
  var shop , product;
  var _shop, _product;

  @override
  void initState() {
    super.initState();
    _shop = "店舗情報選択画面へ";
    _product = "商品選択画面へ";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(4.0),
                height: containerHeight,
                alignment: Alignment.center,
                child: Text(
                  'Order & Pay',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
              // to ShopSelectionScreen
              _shopselectionContainer(),
              // to ProductSelectionScreen
              _productselectionContainer(),
            ],
          ),
          Expanded(child: Container()),
          // Purchase Button
          _purchasedetailContainer(),
        ],
      ),
    );
  }

  // Containers
  Widget _shopselectionContainer() {
    return Container(
      margin: EdgeInsets.all(4.0),
      height: containerHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () async {
          shop = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShopSelectionScreen(),
              )
          );
          if(shop != null) {
            setState(() {
              _shop = shop;
            });
          }
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          child: Text(
            _shop,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _productselectionContainer() {
    return Container(
      margin: EdgeInsets.all(4.0),
      height: containerHeight,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () async {
          product = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductSelectionScreen(),
              )
          );
          if(product != null) {
            setState(() {
              _product = product;
            });
          }
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey,
                width: 2.0,
              ),
              bottom: BorderSide(
                color: Colors.grey,
                width: 2.0,
              ),
            ),
          ),
          child: Text(
            _product,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _purchasedetailContainer() {
    return Container(
      margin: EdgeInsets.all(4.0),
      alignment: Alignment.bottomCenter,
      child: ElevatedButton(
        child: Text(
          '購入',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PurchaseDetailScreen(shop: shop, product: product,),
              )
          );
        },
      ),
    );
  }

} // end _OrderScreenState