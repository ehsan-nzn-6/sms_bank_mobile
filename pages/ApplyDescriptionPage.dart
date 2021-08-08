import 'package:flutter/material.dart';
import 'package:sms_bank_handler/MainApp.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ApplyDescriptionPage extends StatefulWidget {
  int _smsId;

  ApplyDescriptionPage(this._smsId);

  @override
  _ApplyDescriptionPageState createState() =>
      _ApplyDescriptionPageState(_smsId);
}

class _ApplyDescriptionPageState extends State<ApplyDescriptionPage> {
  var descriptionController = TextEditingController();
  int _smsId;

  _ApplyDescriptionPageState(this._smsId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ثبت توضیحات',
          style: TextStyle(
            color: Colors.black45,
          ),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MainApp()));
          },
          borderRadius: BorderRadius.circular(40),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black45,
          ),
        ),
        backgroundColor: Colors.white,
        // elevation: 0,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 250,
          ),
          Container(
            margin: EdgeInsets.only(left: 50, right: 50, top: 10),
            child: Material(
              // borderRadius: BorderRadius.circular(40),
              // shadowColor: Colors.grey[300],
              // elevation: 30,
              child: TextField(
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'توضیحات',
                  hintStyle: TextStyle(color: Colors.black38),
                  // contentPadding: EdgeInsets.only(right: 20),
                  // border: InputBorder.none,
                  // icon: Padding(
                  //   padding: EdgeInsets.only(left: 20, right: 10),
                  // child: Icon(
                  //   Icons.email_rounded,
                  //   color: Colors.cyan,
                  // ),
                  // ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 50, right: 50, top: 20),
            // color: Colors.red,
            height: 50,
            width: 295,
            decoration: BoxDecoration(
                // border: Border.all(color: Colors.lightBlueAccent),
                // borderRadius: BorderRadius.circular(40),
                ),
            child: Material(
              // borderRadius: BorderRadius.circular(40),
              // shadowColor: Colors.lightBlueAccent,
              // elevation: 15,
              child: InkWell(
                onTap: () {
                  saveDescription(this._smsId, descriptionController.text);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => MainApp()));
                },
                borderRadius: BorderRadius.circular(40),
                child: Center(
                  child: Text(
                    'ثبت',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void saveDescription(int smsId, var descriptionController) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'sms_bank.db');
    Database database = await openDatabase(
      path,
      version: 1,
    );
    // print(descriptionController);
    // Update some record
    int count = await database.rawUpdate(
        'UPDATE sms_bank_list SET description = ? WHERE id = ?',
        [descriptionController, smsId]);
    await database.close();
  }
}
