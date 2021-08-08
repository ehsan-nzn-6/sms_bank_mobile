import 'package:flutter/material.dart';
import 'package:sms_bank_handler/pages/CreateAccOrLogin.dart';
import 'package:sms_bank_handler/MainApp.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sms_bank_handler/utils/ReadSms.dart';

class StarterPage extends StatefulWidget {
  const StarterPage({Key? key}) : super(key: key);

  @override
  _StarterPageState createState() => _StarterPageState();
}

class _StarterPageState extends State<StarterPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ReadSms.read();
    readSecKey();
  }

  void readSecKey() async {
    final storage = new FlutterSecureStorage();
    String? userToken = await storage.read(key: 'token');
    String? usemail = await storage.read(key: 'email');
    String? id = await storage.read(key: 'userID');
    // print('---------------------------');
    // print(userToken);
    // print(usemail);
    // print(id);
    // print('---------------------------');
    if (userToken != null) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => MainApp()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CreateAccOrLogin()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
