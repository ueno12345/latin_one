import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final List<String> entries = <String>['6', '7'];

  @override
  Widget build(BuildContext context) {
    // データを取得するための関数
    Future<List<Map<String, dynamic>>> getDocumentData() async {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('inbox')
          .get();
      List<Map<String, dynamic>> inboxList = [];
      for (var docSnapshot in snapshot.docs) {
        inboxList.add(docSnapshot.data() as Map<String, dynamic>);
      }
      return inboxList;
    }
    return Scaffold(
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

              print(snapshot.data![0].entries);
              List<MapEntry<String, dynamic>> informationList = snapshot.data![0].entries.toList();
              List<MapEntry<String, dynamic>> productInformationList = snapshot.data![1].entries.toList();
              List<MapEntry<String, dynamic>> shopInformationList = snapshot.data![2].entries.toList();

              // 取得したデータを表示するWidget
              return DefaultTabController(
                  length: 3,
                  child: Scaffold (
                    appBar: AppBar(
                      title: const Text('Information'),
                      bottom: const TabBar(
                        tabs: [
                          Tab(text: 'General'),
                          Tab(text: 'New Product'),
                          Tab(text: 'New Shop'),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        infoList(informationList),
                        infoList(productInformationList),
                        infoList(shopInformationList)
                      ],
                    ),
                  ),
              );
            }
        )
    );
  }
}

Widget infoList(List<MapEntry<String, dynamic>> informationList){
  return ListView.builder(
      itemCount: informationList.length,
      itemBuilder: (context, index) {
        final info = informationList[index].value;
        return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const Icon(
                      Icons.add_sharp
                    )
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          info['date'],
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          info['body'],
                          style: const TextStyle(fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
        );
      }
  );
}