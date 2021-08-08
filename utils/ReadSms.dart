import 'package:telephony/telephony.dart';
import 'package:sms_bank_handler/main.dart' as main;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sms_bank_handler/MainApp.dart';
import 'package:flutter/material.dart';

class ReadSms {
  static void dbHandler(SmsMessage message) async {
    //////////////////////// DB STARTED : ////////////////////////
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'sms_bank.db');

// Delete the database
//     await deleteDatabase(path);

// open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE sms_bank_list (id INTEGER PRIMARY KEY, address TEXT, message TEXT, description TEXT, datetime DATETIME)');
    });

// Insert some records in a transaction
    await database.transaction((txn) async {
      // int id1 = await txn.rawInsert(
      //     'INSERT INTO sms_bank_list(address, message, datetime) VALUES("${message.address}", "${message.body}", now())');
      // print('inserted1: $id1');
      int id2 = await txn.rawInsert(
          'INSERT INTO sms_bank_list(address, message, datetime) VALUES(?, ?, CURRENT_TIMESTAMP)',
          [message.address, message.body]);
      // print('inserted2: $id2');
    });

    // // Update some record
    // int count = await database.rawUpdate(
    //     'UPDATE Test SET name = ?, value = ? WHERE name = ?',
    //     ['updated name', '9876', 'some name']);
    // print('updated: $count');

// Get the records
    // List<Map> expectedList = [
    //   {'name': 'updated name', 'id': 1, 'value': 9876, 'num': 456.789},
    //   {'name': 'another name', 'id': 2, 'value': 12345678, 'num': 3.1416}
    // ];
    // print(list);
    // print(expectedList);
    // assert(const DeepCollectionEquality().equals(list, expectedList));

// Count the records
//     count = Sqflite.firstIntValue(
//         await database.rawQuery('SELECT COUNT(*) FROM Test'));
//     assert(count == 2);

// Delete a record
//     count = await database
//         .rawDelete('DELETE FROM Test WHERE name = ?', ['another name']);
//     assert(count == 1);

// Close the database
    await database.close();

    // print('----------------------------------------------');
    // print(list);
    // print('----------------------------------------------');
    //////////////////////// DB FINISHED : ////////////////////////
    //////////// SEND NOTIF ////////////////
  }

  //todo: get getterNumber from database
  static void read({String getterNumber = '98700717'}) async {
    final Telephony telephony = Telephony.instance;
    telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          // Handle message
          if (getterNumber == message.address) {
            dbHandler(message);
          }
        },
        onBackgroundMessage: main.backgrounMessageHandler);
  }
}
