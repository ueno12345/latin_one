import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShopDetailScreen extends StatefulWidget {
  const ShopDetailScreen({super.key});

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  static const containerHeight = 120.0;

  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> getDocumentData() async {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('shops')
          .doc('javanican')
          .get();
      return snapshot.data() as Map<String, dynamic>;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'JAVANICAN',
            style: TextStyle(
                color: Colors.red,
              ),
          ),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder(
          future: getDocumentData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            }
            // エラー時に表示するWidget
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text('Error');
            }

            // データが取得できなかったときに表示するWidget
            if (!snapshot.hasData) {
              return Text('No Data');
            }
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(4.0),
                    height: containerHeight,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              snapshot.data?['address'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              _openPhoneApp(snapshot.data?['phone_number']);
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                            _openMapApp(snapshot.data?['geopoint']);
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.map_sharp,
                                color: Colors.black
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildContainer('BUSINESS\nHOURS', snapshot.data?['business_hours']['open'] + '~' + snapshot.data?['business_hours']['close']),
                  _buildContainer('REGULAR\nHOLIDAY', 'Irregular'),
                  _buildContainer('WIRELESS\nHOTSPOT', '後で決める'),
                  _buildContainer('MOBILE\nPAYMENT', 'Cash'),
                  _buildContainer('SERVICE', 'Mobile Order'),
                ],
              )
            );
          }
      ),
    );
  }

  void _openPhoneApp(String phonenumber) async{

    final Uri _phonenumber = Uri(
        scheme: 'tel',
        path:phonenumber
    );
    if (!await launchUrl(_phonenumber)) {
      throw Exception('Could not call $_phonenumber');
    }
  }

  void _openMapApp(GeoPoint point) async{
    final _mapurl = Uri(
        scheme: 'https',
        host: 'www.google.com',
        path: 'maps/search/',
        queryParameters: {'api': '1', 'query': point.latitude.toString() + ',' + point.longitude.toString()}
    );
    print(_mapurl);
    if (!await launchUrl(
        _mapurl,
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_mapurl');
    }
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

