import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import './shopdetailscreen.dart';

class _JavanicanMarker extends Marker {
  static const position = LatLng(33.57467445693053, 133.57844092600828);
  static const size = 100.0;

  _JavanicanMarker(BuildContext context)
      : super(
          height: _JavanicanMarker.size,
          width: _JavanicanMarker.size,
          point: position,
          child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              _showPopupMenu(details, context);
            },
            behavior: HitTestBehavior.deferToChild,
            child: Icon(
              Icons.place,
              color: Colors.red,
              size: 40.0,
            ),
          ),
        );
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

// class _JavanicanCircleMarker extends CircleMarker {
//   _JavanicanCircleMarker()
//       : super(
//           point: _JavanicanMarker.position,
//           useRadiusInMeter: true,
//           radius: 2500,
//           color: Colors.green.withOpacity(0.1),
//           borderColor: Colors.white,
//           borderStrokeWidth: 2.0,
//         );
// }

class ShopsScreen extends StatefulWidget {
  const ShopsScreen({super.key});

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
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
            markers: [
              _JavanicanMarker(context),
            ],
          ),
          // CircleLayer(
          //   circles: [
          //     _JavanicanCircleMarker(),
          //   ],
          // ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
