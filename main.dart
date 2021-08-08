import 'package:flutter/material.dart';
import 'package:sms_bank_handler/pages/StarterPage.dart';
import 'package:telephony/telephony.dart';
import 'package:sms_bank_handler/utils/ReadSms.dart';

backgrounMessageHandler(SmsMessage message) async {
  //Handle background message
  // print('111111111111111111111111');
  print(message.body);

  if ('98700717' == message.address) {
    ReadSms.dbHandler(message);
  }
  // print('222222222222222222222222');
  print(message.body);
}

void main() {
  runApp(StarterPageMaterial());
}

class StarterPageMaterial extends StatelessWidget {
  const StarterPageMaterial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StarterPage(),
    );
  }
}

// class CreateAccOrLogin extends StatefulWidget {
//   const CreateAccOrLogin({Key? key}) : super(key: key);
//
//   @override
//   _CreateAccOrLoginState createState() => _CreateAccOrLoginState();
// }
//
// class _CreateAccOrLoginState extends State<CreateAccOrLogin> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     readSecKey();
//   }
//
//   void readSecKey() async {
//     final storage = new FlutterSecureStorage();
//     String? userToken = await storage.read(key: 'token');
//     print('---------------------------');
//     print(userToken);
//     print('---------------------------');
//     if (userToken != null) {
//       Navigator.of(context)
//           .pushReplacement(MaterialPageRoute(builder: (context) => MainApp()));
//     } else {
//       Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => LoginPage()));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         // decoration: BoxDecoration(
//         //     image: DecorationImage(
//         //         image: NetworkImage(
//         //             "https://oyebesmartest.com/ifetch/115513299325ek55nr8un8qqhatyti1fip2amjxr8f3nnkz2h5siwurotrssysemnbpxek5q8m7uophqj97wmvzgzprpa9nefghhivukjyryhdi.jpg/original"),
//         //         fit: BoxFit.cover)),
//
//         // margin: EdgeInsets.only(top: 350, left: 50, right: 50, bottom: 300),
//         child: Center(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 350,
//               ),
//               Material(
//                 elevation: 30,
//                 borderRadius: BorderRadius.circular(30),
//                 color: Colors.white,
//                 shadowColor: Colors.teal,
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => RegisterPage()));
//                   },
//                   borderRadius: BorderRadius.circular(30),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Colors.teal, // red as border color
//                       ),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     height: 50,
//                     width: 300,
//                     child: Center(
//                         child: Text(
//                       'ثبت نام',
//                       style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.teal,
//                       ),
//                     )),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Material(
//                 elevation: 30,
//                 borderRadius: BorderRadius.circular(30),
//                 color: Colors.teal,
//                 shadowColor: Colors.teal[300],
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.of(context).push(
//                         MaterialPageRoute(builder: (context) => LoginPage()));
//                   },
//                   borderRadius: BorderRadius.circular(30),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: Colors.teal, // red as border color
//                       ),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     height: 50,
//                     width: 300,
//                     child: Center(
//                         child: Text(
//                       'ورود',
//                       style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.white,
//                       ),
//                     )),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//
// Material(
// elevation: 30,
// borderRadius: BorderRadius.circular(30),
// shadowColor: Colors.grey[400],
// child: TextField(
// textDirection: TextDirection.rtl,
// textAlign: TextAlign.left,
// decoration: InputDecoration(
// hintText: 'ایمیل',
// hintStyle: TextStyle(),
// contentPadding: EdgeInsets.only(left: 20, right: 20),
// border: InputBorder.none,
// ),
// ),
// ),
