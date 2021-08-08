import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sms_bank_handler/widgets/NavDrawer.dart';
import 'package:sms_bank_handler/MainBottonNav.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sms_bank_handler/pages/ApplyDescriptionPage.dart';
import 'package:jalali_calendar/jalali_calendar.dart';
import 'package:sms_bank_handler/utils/SyncWithServer.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<Map> _items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    syncWithDB();
  }

  void syncWithDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'sms_bank.db');
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE sms_bank_list (id INTEGER PRIMARY KEY, address TEXT, message TEXT, datetime DATETIME)');
    });

    List<Map> data = await database.rawQuery('SELECT * FROM sms_bank_list');

    await database.close();
    setState(() {
      _items.clear();
      _items.addAll(data);
      _items = _items.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'صفحه اصلی',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => {syncWithDB()},
            icon: Icon(
              Icons.refresh,
              color: Colors.pink,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(Duration(microseconds: 1), () async {
            syncWithDB();
          });
        },
        child: SingleChildScrollView(
          child: Column(
            //SingleChildScrollView
            children: List.generate(
              _items.length,
              (int position) => generateItem(_items[position], context),
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     SyncWithServer.syncAll();
      //   },
      //   label: Text(
      //     'Sync',
      //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //   ),
      //   icon: Icon(
      //     Icons.sync,
      //     size: 28,
      //   ),
      //   backgroundColor: Colors.pink,
      // ),
      bottomNavigationBar: MainBottomNav(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget generateItem(objDB, context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ApplyDescriptionPage(objDB['id'])));
      },
      child: Container(
        // margin: EdgeInsets.only(top: 20, bottom: 50),
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        // height: 100,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12,
          ),
          // borderRadius: BorderRadius.circular(10.0),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(objDB['address'],
                  textDirection: TextDirection.ltr, style: TextStyle()),
            ),
            SizedBox(
              height: 20,
            ),
            Text(objDB['message'],
                textDirection: TextDirection.rtl, style: TextStyle()),

            //),
            SizedBox(
              height: 20,
            ),
            getDescription(objDB),
            SizedBox(
              height: 30,
            ),
            Center(
              child: getPersianDatetime(
                objDB['datetime'],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getPersianDatetime(datetime) {
    List<String> date = datetime.split(' ')[0].split('-');
    List<String> time = datetime.split(' ')[1].split(':');
    PersianDate persianDateLib = PersianDate();
    String persianDate = persianDateLib.gregorianToJalali(
        int.parse(date[0]), int.parse(date[1]), int.parse(date[2]), '/');
    String persianTime = timeConverter(
        int.parse(time[0]), int.parse(time[1]), int.parse(time[2]));
    return Text('$persianDate $persianTime',
        textDirection: TextDirection.ltr, style: TextStyle());
  }

  String timeConverter(int h, int m, int s) {
    m += 30;
    if (59 < m) {
      h++;
      m -= 60;
    }
    h += 4;

    return '$h:$m:$s';
  }

  Widget getDescription(objDB) {
    // print('----------------------------------------------');
    // print(objDB['message'].contains('+'));
    // // print(objDB['message'].toString().split('\n')[1]);
    // print('----------------------------------------------');

    var description = objDB['description'];
    if (description != null && description != '') {
      if (objDB['message'].contains('+')) {
        return Container(
          margin: EdgeInsets.all(15.0),
          padding: EdgeInsets.all(10),
          // height: 200,
          // width: ,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green),
          ),
          child: Center(
              child: Text(description,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: Colors.green[400]))),
        );

        // Text(description,
        //     textDirection: TextDirection.rtl,
        //     style: TextStyle(color: Colors.green[400]));
      }
      return Container(
        margin: EdgeInsets.all(15.0),
        padding: EdgeInsets.all(10),
        // height: 200,
        // width: ,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
        ),
        child: Center(
            child: Text(description,
                textDirection: TextDirection.rtl,
                style: TextStyle(color: Colors.red[400]))),
      );
    }
    return Container(
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(10),
      // height: 200,
      // width: ,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
      ),
      child: Center(
          child: Text('چیزی ثبت نشده!',
              textDirection: TextDirection.rtl,
              style: TextStyle(color: Colors.blueGrey))),
    );
  }
}
