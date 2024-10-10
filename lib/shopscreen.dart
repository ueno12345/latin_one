import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './shopdetailscreen.dart';

class ShopsScreen extends StatefulWidget {
  const ShopsScreen({super.key});

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  @override
  Widget build(BuildContext context) {
    // データを取得するための関数
    Future<List<dynamic>> getDocumentData() async {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('shops')
          .get();
      List<dynamic> shopList = [];
      for (var docSnapshot in snapshot.docs) {
        shopList.add(docSnapshot.data());
      }
      return shopList;
    }
    return Scaffold(
        body: FutureBuilder(
          future: getDocumentData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }
            // エラー時に表示するWidget
            if (snapshot.hasError) {
              return const Text('Error');
            }

            // データが取得できなかったときに表示するWidget
            if (!snapshot.hasData) {
              return const Text('No Data');
            }

            List<_ShopMarker> shopMarkerList = [];

            for (final marker in snapshot.data!) {
              shopMarkerList.add(_ShopMarker(marker, context));
            }

            return FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(33.57467445693053, 133.57844092600828),
                initialZoom: 13.0,
                minZoom: 9.0,
                maxZoom: 18.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: shopMarkerList,
                ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () =>
                          launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                    ),
                  ],
                ),
              ],
            );},
        )
    );
  }
}

class _ShopMarker extends Marker {
  static const size = 100.0;

  _ShopMarker(Map<String, dynamic> shop, BuildContext context)
      : super(
          height: _ShopMarker.size,
          width: _ShopMarker.size,
          point: LatLng(shop['geopoint'].latitude, shop['geopoint'].longitude),
          child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              _showPopupMenu(shop, details, context);
            },
            behavior: HitTestBehavior.deferToChild,
            child: const Icon(
              Icons.place,
              color: Colors.red,
              size: 40.0,
            ),
          ),
        );
}

void _showPopupMenu(Map<String, dynamic> shop, TapDownDetails details, BuildContext context) {
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
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    shop['name'].toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    shop['address'].toString(),
                    style: const TextStyle(
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
      const PopupMenuItem<String>(
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
        MaterialPageRoute(builder: (context) => ShopDetailScreen(shop: shop)),
      );
    } else if (value == 'close') {
      // 何も書かんかったらそのまま閉じる
    }
  });
}