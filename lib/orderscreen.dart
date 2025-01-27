import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './shopselectionscreen.dart';
import './deliveryaddressscreen.dart';
import './productselectionscreen.dart';
import './purchasedetailscreen.dart';
import 'router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  static const containerHeight = 80.0;
  var shop;
  var _shop, _address, _cart;
  num sum = 0;
  List<Map<String, String>> deliveryaddress = [];
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
                margin: const EdgeInsets.all(4.0),
                height: containerHeight/2,
                alignment: Alignment.center,
                child: const Text(
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
          const Padding(
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
      margin: const EdgeInsets.all(4.0),
      height: containerHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
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
                builder: (context) => const ShopSelectionScreen(),
              )
          );
          if(shop != null) {
            setState(() {
              _shop = shop;
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.all(4.0),
          alignment: Alignment.centerLeft,
          child: Text(
            _shop,
            style: const TextStyle(
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
      margin: const EdgeInsets.all(4.0),
      height: containerHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
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
            deliveryaddress = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeliveryAddressScreen(),
                )
            );

          }

          if(deliveryaddress != []) {
            setState(() {
              _address = deliveryaddress[3]['address'];
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.all(4.0),
          alignment: Alignment.centerLeft,
          child: Text(
            _address,
            style: const TextStyle(
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
      margin: const EdgeInsets.all(4.0),
      height: containerHeight,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () async {
          if(shop != null) {
            final List<Map<String, dynamic>> result = await Navigator.push<List<Map<String, dynamic>>>(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductSelectionScreen(cart: cart, id: id, shop: shop),
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
          padding: const EdgeInsets.all(4.0),
          alignment: Alignment.centerLeft,
          decoration: const BoxDecoration(
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
            style: const TextStyle(
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
      margin: const EdgeInsets.all(4.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 12.0),
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 12.0),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey
                ),
              )
            ),
            child: const Text(
              'カート内容',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: Scrollbar(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: cart.length,
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return _selectedProduct(cart[index]);
                },
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              "総合計: ¥$sum",
              style: const TextStyle(
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
                      title: const Text("商品を削除しますか？"),
                      content: const Text("カートから選択した商品を削除します"),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
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
                            },
                            child: const Text(
                              "OK",
                            )
                        ),
                      ],
                    );
                  }
              );
            },
            child: const Icon(
                Icons.remove_circle_outline
            )
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.all(4.0),
              child: Text(
                product['name'].toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              )),
        ),
        Expanded(
          flex: 1,
          child: Container(
              margin: const EdgeInsets.all(4.0),
              child: Text(
                "${product['pieces']}点",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              )
          ),
        ),
        Expanded(
            flex: 1,
            child: Container(
                margin: const EdgeInsets.all(4.0),
                child: Text(
                  "¥${int.parse(product['price']) * int.parse(product['pieces'])}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.right,
                )
            )
        ),
      ],
    );
  }

  Widget _purchasedetailContainer() {
    return Container(
      margin: const EdgeInsets.all(4.0),
      alignment: Alignment.bottomCenter,
      child: ElevatedButton(
        onPressed: () async {
          if(shop != null && deliveryaddress != [] && cart.isNotEmpty) {
            // Order ID を取得
            final orderCounterDoc = FirebaseFirestore.instance.collection("topicCounters").doc("order");
            orderCounterDoc.get().then(
                  (DocumentSnapshot doc) {
                    final orderIdMap = doc.data() as Map<String, dynamic>;
                    num orderId = orderIdMap['currentId'];
                    // Order インスタンスを作成
                    var order = {
                      orderId.toString() : {
                        'order-time' : DateTime.now(),
                        '氏名' : deliveryaddress[0]['name'].toString(),
                        'ニックネーム' : deliveryaddress[1]['nickname'].toString(),
                        'mail-address' : deliveryaddress[2]['mail'].toString(),
                        '店舗' : _shop,
                        '配送先' : deliveryaddress[3]['address'],
                        '注文商品' : cart,
                        '注文合計' : sum,
                        '配送状況' : false,
                      },
                    };
                    // Order を FireStore に追加
                    FirebaseFirestore.instance.collection('order').doc('order').set(order, SetOptions(merge: true));
                    // Order ID を更新
                    orderId += 1;
                    FirebaseFirestore.instance.collection('topicCounters').doc('order').set({'currentId' : orderId});
                  },
              onError: (e) => print("Error getting document: $e"),
            );

            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PurchaseDetailScreen(shop: shop, name: deliveryaddress[0]['name'], nickname: deliveryaddress[1]['nickname'], address: deliveryaddress[3]['address'], cart: cart),
                )
            );

            if(result != null && result == "home"){
              goRouter.go('/');
            }
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: (shop != null && deliveryaddress != [] && cart.isNotEmpty) ? Colors.amber : Colors.amber[100]),
        child: Text(
          '購入',
          style: TextStyle(
            color: (shop != null && deliveryaddress != [] && cart.isNotEmpty) ? Colors.black : Colors.white,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
