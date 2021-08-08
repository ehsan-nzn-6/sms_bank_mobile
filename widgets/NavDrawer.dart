import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sms_bank_handler/main.dart';
import 'package:sms_bank_handler/pages/StarterPage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'منو',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
          ),
          // ListTile(
          //   leading: Icon(Icons.input),
          //   title: Text('Welcome'),
          //   onTap: () => {},
          // ),
          // ListTile(
          //   leading: Icon(Icons.verified_user),
          //   title: Text('Profile'),
          //   onTap: () => {Navigator.of(context).pop()},
          // ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'تنظیمات',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text(
              'بازخورد',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            onTap: () {
              // Navigator.of(context)
              //     .push(MaterialPageRoute(builder: (context) => ));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: Text(
              'خروج از حساب',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            onTap: () async {
              final storage = new FlutterSecureStorage();
              await storage.delete(key: 'token');
              await storage.delete(key: 'email');
              await storage.delete(key: 'userID');

              var databasesPath = await getDatabasesPath();
              String path = join(databasesPath, 'sms_bank.db');

              await deleteDatabase(path);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => StarterPage()));
            },
          ),
        ],
      ),
    );
  }
}
