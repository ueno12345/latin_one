import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class _JavanicanMarker extends Marker {
  static const position = LatLng(33.57527338772311, 133.5784302);

  _JavanicanMarker()
    : super(
        point: position,
        child: Icon(
          Icons.place,
          color: Colors.red,
          size: 24.0,
        )
      );
}

class _JavanicanCircleMarker extends CircleMarker {
  _JavanicanCircleMarker()
    : super(
        point: _JavanicanMarker.position,
        useRadiusInMeter: true,
        // スタバは半径5kmかも
        radius: 2500,
        color: Colors.green.withOpacity(0.1),
        borderColor: Colors.white,
        borderStrokeWidth: 2.0,
      );
}

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
        initialCenter: LatLng(33.57527338772311, 133.5784302),
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
              _JavanicanMarker(),
            ],
          ),
          CircleLayer(
            circles: [
              _JavanicanCircleMarker(),
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
