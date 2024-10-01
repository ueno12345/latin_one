import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.ChangeIndex, required this.ChangeInboxFlag});

  final Function(int) ChangeIndex;
  final Function(int) ChangeInboxFlag;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const containerHeight = 250.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildContainer('image2.jpg', 'Shops', 'SEARCH SHOPS', '注文可能な店舗を検索', '検索する'),
            _buildContainer('image3.jpg', 'Order', 'MOBILE ORDER', 'レジに並ばずお店で受け取り', 'オーダーする'),
            _buildContainer('image4.jpg', 'New Products', "What's new", 'Daily Offering', 'もっと見る'),
            _buildContainer('image5.jpg', 'Products', 'Check Products', '商品一覧を確認', 'もっと見る'),
            _buildContainer('image6.jpg', 'Inbox', 'New information', '新しい情報', 'もっと見る'),
          ]
        )
      ),
    );
  }

  Widget _buildContainer(String image, String destination, String title, String description, String text) {
    return Container(
      height: containerHeight,
      child: GestureDetector(
        onTap: () => onPageChange(destination),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              child: Image.asset(
                "images/" + image,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: containerHeight / 5,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                      ),
                    ),
                    alignment: Alignment.bottomLeft,
                  ),
                  Container(
                    height: containerHeight * 2 / 5,
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  _showButton(destination, text)
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showButton(String destination, String text) {
    return Container(
      height: containerHeight * 2 / 5,
      alignment: Alignment.centerLeft,
      child: ElevatedButton(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
        onPressed: () => onPageChange(destination),
      ),
    );
  }

  void onPageChange(destination) {
    setState(() {
      switch (destination) {
        case 'Order':
          widget.ChangeIndex(1);
          break;
        case 'Shops':
          widget.ChangeIndex(2);
          break;
        case 'Inbox':
          widget.ChangeInboxFlag(1);
          break;
        default:
          widget.ChangeIndex(0);
          break;
      }
    });
  }
}
