import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latin_one/orderscreen.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class _JavanicanMarker extends Marker {
  static const position = LatLng(33.57467445693053, 133.57844092600828);
  static const size = 100.0;

  _JavanicanMarker(BuildContext context)
      : super(
    height: _JavanicanMarker.size,
    width: _JavanicanMarker.size,
    point: position,
    child: GestureDetector(
      onTapDown: (TapDownDetails details){
        Navigator.of(context).pop("javanican");
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




class ShopSelectionScreen extends StatefulWidget {
  const ShopSelectionScreen({super.key});

  @override
  State<ShopSelectionScreen> createState() => _ShopSelectionScreenState();
}

class _ShopSelectionScreenState extends State<ShopSelectionScreen> {
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
