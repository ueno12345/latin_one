import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:email_validator/email_validator.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  List<Map<String, String>> deliveryaddress = List.unmodifiable([{"name":""}, {"mail":""}, {"address":""}]);
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final zipCodeController = TextEditingController();
  final prefController = TextEditingController();
  final cityController = TextEditingController();
  final streetController = TextEditingController();
  final buildingController = TextEditingController();


  var _buttonbgcolor = Colors.amber[100];
  var _buttontextcolor = Colors.white;
  var addressMap;


  @override
  Widget build(BuildContext context) {
    bool canPress(){
      return (nameController.text.isNotEmpty &&
              EmailValidator.validate(mailController.text) &&
              addressMap != null &&
              streetController.text.isNotEmpty);
    }
    void changebuttoncolor(){
      if(canPress()) {
        setState(() {
          _buttonbgcolor = Colors.amber;
          _buttontextcolor = Colors.black;
        });
      }else{
        setState(() {
          _buttonbgcolor = Colors.amber[100];
          _buttontextcolor = Colors.white;
        });
        }
      }
    nameController.addListener((){changebuttoncolor();});
    mailController.addListener((){changebuttoncolor();});
    zipCodeController.addListener((){changebuttoncolor();});
    streetController.addListener((){changebuttoncolor();});
    return WillPopScope(
        onWillPop: () {
          //左上の戻るボタンを押下したら何も返さない
          Navigator.pop(context, null);
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Delivery Address',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.amber,
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                    hintText: '氏名(必須)',
                    ),
                    controller: nameController,
                  ),

                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction, //値が変わるたびにvalidatorを呼び出す
                    decoration: const InputDecoration(
                      hintText: 'メールアドレス(必須)',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? value){
                      return (value != null && !EmailValidator.validate(value))?  '有効なメールアドレスを入力してください': null;
                    },
                    controller: mailController,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction, //値が変わるたびにvalidatorを呼び出す
                    decoration: const InputDecoration(
                      hintText: '郵便番号(必須)',
                    ),
                    maxLength: 7,
                    onChanged: (value) async {
                      // 入力された文字数が7以外なら終了
                      if (value.length != 7) {
                        return;
                      }
                      addressMap = await zipCodeToAddress(value);
                      // 返ってきた値がnullなら終了
                      if (addressMap == null) {
                        const snackBar = SnackBar(
                          content: Text("住所がヒットしませんでした．"),
                          duration: Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        return;
                      } else {
                        prefController.text = addressMap['address1'];
                        cityController.text =
                        '${addressMap['address2']} ${addressMap['address3']}';
                      }
                    },
                    controller: zipCodeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: '都道府県(必須)',
                    ),
                    controller: prefController,
                    enabled: false,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: '市区町村(必須)',
                    ),
                    controller: cityController,
                    enabled: false,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: '番地(必須)',
                    ),
                    controller: streetController,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: '建物名(任意)',
                    ),
                    controller: buildingController,
                  ),
                  ElevatedButton(
                    child: Text(
                      '決定',
                      style: TextStyle(
                        color: _buttontextcolor,
                        fontSize: 24,
                      ),
                    ),
                    onPressed: (nameController.text.isEmpty ||
                                !EmailValidator.validate(mailController.text) ||
                                addressMap == null ||
                                streetController.text.isEmpty) ? //バリデーション実行
                      null : //バリデーションが通ってない場合，押せないようにする
                      (){ //バリデーションが通っている場合，各フィールドの値を変数に詰める
                        deliveryaddress[0]['name'] = nameController.text;
                        deliveryaddress[1]['mail'] = mailController.text;
                        deliveryaddress[2]['address'] = "〒"+ zipCodeController.text + " " +
                                                        prefController.text +
                                                        cityController.text +
                                                        streetController.text +
                                                        buildingController.text;
                        Navigator.pop(context, deliveryaddress);
                      },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: _buttonbgcolor,
                      disabledBackgroundColor: _buttonbgcolor
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }

}


Future<Map<String?, dynamic>?> zipCodeToAddress(String zipCode) async {
  if (zipCode.length != 7) {
    return null;
  }
  final response = await get(
    Uri.parse(
      'https://zipcloud.ibsnet.co.jp/api/search?zipcode=$zipCode',
    ),
  );
  // 正常なステータスコードが返ってきているか
  if (response.statusCode != 200) {
    return null;
  }
  // ヒットした住所はあるか
  final result = jsonDecode(response.body);
  if (result['results'] == null) {

    return null;
  }
  final addressMap = (result['results'] as List).first; // 結果が2つ以上のこともあるが、簡易的に最初のひとつを採用することとする。

  return addressMap;
}


