import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  var shop;
  var _shop, _cart;
  List<Map<String, dynamic>> cart = [];
  var id = 1;

  @override
  void initState() {
    super.initState();
    _shop = "店舗情報選択画面へ";
    _cart = "商品選択画面へ";
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
                height: containerHeight/2,
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
          if(shop != null) {
            cart = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductSelectionScreen(cart: cart, id:id),
                )
            );
            if (cart != null) {
              setState(() {
                _cart = cart;
              });
            }
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
            _cart,
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
            color: (shop != null && cart != null) ? Colors.black : Colors.white,
            fontSize: 24,
          ),
        ),
        onPressed: () async {
          if(shop != null && cart != null) {
            final data = ClipboardData(text: "店舗名: ${shop}\n商品: ${cart}");
            await Clipboard.setData(data);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PurchaseDetailScreen(shop: shop, cart: cart,),
                )
            );
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: (shop != null && cart != null) ? Colors.amber : Colors.amber[100]),
      ),
    );
  }
}
