import 'package:flutter/material.dart';

class ProductPopupScreen extends StatefulWidget {
  final image;
  final product;
  final description;
  const ProductPopupScreen({super.key, required this.image, required this.product, required this.description});

  @override
  State<ProductPopupScreen> createState() => _ProductPopupScreenState();
}

class _ProductPopupScreenState extends State<ProductPopupScreen> {
  static const containerHeight = 160.0;
  var piece = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: [
                // imageとproduct name
                Container(
                  height: 140,
                  child: Image.asset(
                      //widget.image.toString()
                      "images/image1.jpg"
                  ),
                ),
                Container(
                  child: Text(
                      "${widget.product}"
                  ),
                )
              ],
            ),
          ),
          Container(
            height: containerHeight*3/4,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
            ),
            child: Container(
                  child: Container(
                          child: Text(
                            widget.description.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),

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
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8.0,0.0,0.0,0.0),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      "数量",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: Row(
                      children: [
                        GestureDetector(
                          child: const Icon(
                              Icons.remove_circle_outline
                          ),
                          onTap: (){
                            if(piece > 1){
                              _decrementPiece();
                            }
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0),
                          child: Text(
                            piece.toString(),
                            style: const TextStyle(
                                fontSize: 30
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: const Icon(
                              Icons.add_circle_outline
                          ),
                          onTap: () {
                            if (piece < 20) {
                              _incrementPiece();
                            }
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      _selectButton()
        ],
      ),
    );
  }

  void _incrementPiece() {
    setState(() {
      piece++; // カウントを1増やす
    });
  }

  void _decrementPiece() {
    setState(() {
      piece--; // カウントを1増やす
    });
  }

  Widget _selectButton() {
    return Container(
      margin: const EdgeInsets.all(4.0),
      alignment: Alignment.bottomCenter,
      child: ElevatedButton(
        child: const Text(
          '選択',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
        onPressed: () async {
            // 数量を返す
              Navigator.pop(context, piece.toString());
        },
      ),
    );
  }
}
