import 'package:flutter/material.dart';
import './shopselectionscreen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  static const containerHeight = 120.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
            Container(
              margin: EdgeInsets.all(4.0),
              height: containerHeight,
              alignment: Alignment.center,
              child: GestureDetector(
                onTapDown: (TapDownDetails details) {
                  _showPopupMenu(details, context);
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Text(
                    '店舗情報選択画面へ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),

            _buildContainer('BUSINESS\nHOURS', '08:30 ~ 18:00'),
            _buildContainer('REGULAR\nHOLIDAY', 'Irregular'),
            _buildContainer('WIRELESS\nHOTSPOT', '後で決める'),
            _buildContainer('MOBILE\nPAYMENT', 'Cash'),
            _buildContainer('SERVICE', 'Mobile Order'),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer(String title, String content) {
    return Container(
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
      ),
      height: containerHeight,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                content,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
void _showPopupMenu(TapDownDetails details, BuildContext context) {
  final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
  const xPos = 150.0;
  const yPos = 50.0;

  showMenu(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromLTWH(
        details.globalPosition.dx - xPos,
        details.globalPosition.dy - yPos,
        2*xPos,
        2*yPos,
      ),
      Offset.zero & overlay.size,
    ),
    items: [
      PopupMenuItem<String>(
        value: 'detail',
        child: SizedBox(
          width: 2*xPos,
          height: 2*yPos,
          child:  Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'JAVANICAN',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ここには Address が入る',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ]
          ),
        ),
      ),
      PopupMenuItem<String>(
        value: 'close',
        child: SizedBox(
          width: 2*xPos,
          height: yPos / 2,
          child: Center(
            child: Text(
              '閉じる',
            ),
          ),
        ),
      ),
    ],
  ).then((value) {
    if (value == 'detail') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ShopDetailScreen()),
      );
    } else if (value == 'close') {
      // 何も書かんかったらそのまま閉じる
    }
  });
}