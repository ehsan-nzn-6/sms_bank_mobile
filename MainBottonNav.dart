import 'package:flutter/material.dart';
import 'package:sms_bank_handler/utils/SyncWithServer.dart';

class MainBottomNav extends StatelessWidget {
  const MainBottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 10,
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2 - 60,
              // color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      SyncWithServer.restore(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.download_outlined,
                          color: Colors.blueGrey,
                        ),
                        Text(
                          'Restore',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                  // Icon(
                  //   Icons.person_outline,
                  //   color: Colors.blueGrey,
                  // )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2 - 60,
              // color: Colors.yellow,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      SyncWithServer.backup(context);
                    },
                    child: Row(
                      children: [
                        Text(
                          'Backup',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Icon(
                          Icons.backup_outlined,
                          color: Colors.blueGrey,
                        ),
                      ],
                    ),
                  ),
                  // Icon(
                  //   Icons.shopping_basket,
                  //   color: Colors.blueGrey,
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
