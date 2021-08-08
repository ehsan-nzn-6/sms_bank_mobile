import 'dart:ffi';
import 'package:sms_bank_handler/utils/showMySnackBar.dart';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SyncWithServer {
  static void restore(context) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'sms_bank.db');

    await deleteDatabase(path);

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE sms_bank_list (id INTEGER PRIMARY KEY, address TEXT, message TEXT, description TEXT, datetime DATETIME)');
    });

    final storage = new FlutterSecureStorage();
    var email = await storage.read(key: 'email');

    var smsdataurl = Uri.parse(
        'http://ehsanpage.pythonanywhere.com/api/smsdata/?user__email=${email}');
    var smsdataresponse = await http.get(smsdataurl);
    List<dynamic> dataServerJson =
        json.decode(utf8.decode(smsdataresponse.bodyBytes));

    for (var j = 0; j < dataServerJson.length; j++) {
      var address = dataServerJson[j]['address'];
      var message = dataServerJson[j]['message'];
      var description = dataServerJson[j]['description'];
      var datetime = dataServerJson[j]['datetime'];
      datetime = datetime
          .toString()
          .replaceAll('T', ' '); //server addition details remove
      datetime =
          datetime.toString().substring(0, datetime.toString().indexOf('+'));
      await database.transaction((txn) async {
        int id2 = await txn.rawInsert(
            'INSERT INTO sms_bank_list(address, message, description, datetime) VALUES(?, ?, ?, ?)',
            [address, message, description, datetime]);
        // print('inserted2: $id2');
      });
    }
    await database.close();
    // print('++++++++++++++++++++++++++');
    // print(dbData);
    // print('++++++++++++++++++++++++++');
    // print('/////////////////////////////');
    // print(dataServerJson);
    // print('/////////////////////////////');
    showMySnackBar(context, 'صفحه را رفرش کنید!');
  }

  static void backup(context) async {
    // START: getDataFromDB //
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'sms_bank.db');
    Database database = await openDatabase(path, version: 1);
    List<Map> dbData = await database.rawQuery('SELECT * FROM sms_bank_list');
    await database.close();
    // END: getDataFromDB //
    final storage = new FlutterSecureStorage();
    // var token = await storage.read(key: 'token');
    var email = await storage.read(key: 'email');
    String? userID = await storage.read(key: 'userID');
    // DELETE ALL DATA IN SERVER //
    List<int> wantToDeleteIDs = [];
    var wantToDeleteurl = Uri.parse(
        'http://ehsanpage.pythonanywhere.com/api/smsdata/?user__email=${email}');
    var wantToDeleteresponse = await http.get(wantToDeleteurl);
    var wantToDeleteJson =
        json.decode(utf8.decode(wantToDeleteresponse.bodyBytes));
    for (int j = 0; j < wantToDeleteJson.length; j++) {
      wantToDeleteIDs.add(wantToDeleteJson[j]['id']);
    }

    for (int j = 0; j < wantToDeleteIDs.length; j++) {
      var deleteUrl = Uri.parse(
          'http://ehsanpage.pythonanywhere.com/api/smsdata/rud/${wantToDeleteIDs[j]}/');
      var delresp = await http.delete(deleteUrl,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});
      if (delresp.statusCode == 204) {
        //pass
      } else {
        print('___ 1 ERRORR! ___');
      }
    }

    // DELETE ALL DATA IN SERVER //

    var url = Uri.parse('http://ehsanpage.pythonanywhere.com/api/smsdata/');
    // SEND TO SERVER //
    for (var i = 0; i < dbData.length; i++) {
      var address = dbData[i]['address'];
      var message = dbData[i]['message'];
      String? description = dbData[i]['description'];
      if (description == null) {
        description = '';
      }
      var datetime = dbData[i]['datetime'];
      var user = userID;
      var response = await http.post(url, body: <dynamic, dynamic>{
        'address': address,
        'message': message,
        'description': description,
        'datetime': datetime,
        'user': user,
      });
      if (response.statusCode == 201) {
        //pass
      } else {
        print(response.body);
        print('___ 2 ERRORR! ___');
      }
    }
    showMySnackBar(context, 'بکاپ با موفقیت گرفته شد!');
    // SEND TO SERVER //
  }
}
