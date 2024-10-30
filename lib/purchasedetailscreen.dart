import 'package:flutter/material.dart';

class PurchaseDetailScreen extends StatefulWidget {
  final shop, name, nickname, address, cart;
  const PurchaseDetailScreen({super.key, required this.shop, required this.name, required this.nickname, required this.address, required this.cart});

  @override
  State<PurchaseDetailScreen> createState() => _PurchaseDetailScreenState();
}

class _PurchaseDetailScreenState extends State<PurchaseDetailScreen> {
  static const containerHeight = 160.0;

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () {
          //左上の戻るボタンを押下したらOrderに戻る
          Navigator.pop(context, "home");
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white.withOpacity(0.0),
            elevation: 0.0,
          ),
          body: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                height: containerHeight,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "注文を承りました\nお客様のご来店をお待ち\nしています",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                  ),
                ),
              ),
              Container(
                height: containerHeight * 3 / 4,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                  100.0, 0.0, 0.0, 0.0),
//                        alignment: Alignment.center,
                              child: const Icon(
                                Icons.local_drink_rounded,
                                color: Colors.green,
                                size: 32,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
                              child: Text(
                              "${widget.nickname}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 32,
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text(
                          "${widget.name}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                ),
                height: containerHeight,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "${widget.shop}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                        alignment: Alignment.topLeft,
                        child: Text(
                          "${widget.address}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: containerHeight * 2,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                              child: const Icon(
                                Icons.store_mall_directory_rounded,
                                color: Colors.grey,
                                size: 28,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
                              child: const Text(
                                "How to pick up",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 0.0),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "1.受取時間を目安に店舗に行く\n2.商品の受取カウンターへ\n3.商品ラベルの受取番号(またはニックネーム)を\n確認し、受け取る",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "ドライブスルーレーンでの受け取りはできませ\nん、店内でお受け取りください",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}
