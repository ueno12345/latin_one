import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './shopselectionscreen.dart';
import './deliveryaddressscreen.dart';
import './productselectionscreen.dart';
import './purchasedetailscreen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  static const containerHeight = 80.0;
  var shop, address;
  var _shop, _address, _cart;
  num sum = 0;
  List<Map<String, dynamic>> cart = [];
  var id = 1;

  @override
  void initState() {
    super.initState();
    _shop = "店舗を選択する";
    _address = "配送先を選択する";
    _cart = "商品を選択する";
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
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // to ShopSelectionScreen
              _shopselectionContainer(),
              // to DeliveryAddressScreen
              _deliveryaddressContainer(),
              // to ProductSelectionScreen
              _productselectionContainer(),
            ],
          ),
          Padding(
              padding: EdgeInsets.all(4.0)
          ),
          _cartdisplayContainer(),
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
          padding: EdgeInsets.all(4.0),
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

  Widget _deliveryaddressContainer() {
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
          if(shop != null){
            address = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeliveryAddressScreen(),
                )
            );

          }

          if(address != null) {
            setState(() {
              _address = address;
            });
          }
        },
        child: Container(
          padding: EdgeInsets.all(4.0),
          alignment: Alignment.centerLeft,
          child: Text(
            _address,
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
            final List<Map<String, dynamic>> result = await Navigator.push<List<Map<String, dynamic>>>(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductSelectionScreen(cart: cart, id:id),
                )
            ) ?? cart;
            cart = result;
            if(cart != []) {
              num i = 0;
              for (final product in cart) {
                i = i + int.parse(product['pieces']) * int.parse(product['price']);
              }
              sum = i;
            }
            setState(() {
              _cart = '商品を追加する';
            });
          }
        },
        child: Container(
          padding: EdgeInsets.all(4.0),
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

  Widget _cartdisplayContainer() {
    return Container(
      margin: EdgeInsets.all(4.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 12.0),
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 12.0),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.amber
                ),
              )
            ),
            child: Text(
              'カート内容',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          Container(
            height: 200,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: cart.length,
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              itemBuilder: (BuildContext context, int index) {
                return _selectedProduct(cart[index]);
              },
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              "総合計" + ": " + "¥" + sum.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          )
        ]
      )
    );
  }

  Widget _selectedProduct(Map<String, dynamic> product) {
    return Row(
      children: [
        ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("商品を削除しますか？"),
                      content: Text("カートから選択した商品を削除します"),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "キャンセル",
                            )
                        ),
                        ElevatedButton(
                            onPressed: () {
                              cart.remove(product);
                              sum = sum - int.parse(product['pieces']) * int.parse(product['price']);
                              Navigator.pop(context);
                              setState(() {
                              });
                              print(cart);
                            },
                            child: Text(
                              "OK",
                            )
                        ),
                      ],
                    );
                  }
              );
            },
            child: Icon(
                Icons.remove_circle_outline
            )
        ),
        Container(
          child: Text(
            product['name'].toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
          child: Text(
            product['pieces'].toString() + "点",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
        ),
        Expanded(child: Container()),
        Text(
          "¥" + (int.parse(product['price']) * int.parse(product['pieces'])).toString(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ],
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
            color: (shop != null && address != null && cart.length > 0) ? Colors.black : Colors.white,
            fontSize: 24,
          ),
        ),
        onPressed: () async {
          if(shop != null && address != null && cart.length > 0) {
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
        style: ElevatedButton.styleFrom(backgroundColor: (shop != null && address != null && cart.length > 0) ? Colors.amber : Colors.amber[100]),
      ),
    );
  }
}
