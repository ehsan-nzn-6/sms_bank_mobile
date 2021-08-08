import 'package:flutter/material.dart';
import 'package:sms_bank_handler/pages/RegisterPage.dart';
import 'package:sms_bank_handler/pages/LoginPage.dart';
import 'package:sms_bank_handler/MainApp.dart';

class CreateAccOrLogin extends StatefulWidget {
  const CreateAccOrLogin({Key? key}) : super(key: key);

  @override
  _CreateAccOrLoginState createState() => _CreateAccOrLoginState();
}

class _CreateAccOrLoginState extends State<CreateAccOrLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: NetworkImage(
        //             "https://oyebesmartest.com/ifetch/115513299325ek55nr8un8qqhatyti1fip2amjxr8f3nnkz2h5siwurotrssysemnbpxek5q8m7uophqj97wmvzgzprpa9nefghhivukjyryhdi.jpg/original"),
        //         fit: BoxFit.cover)),

        // margin: EdgeInsets.only(top: 350, left: 50, right: 50, bottom: 300),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 350,
              ),
              Material(
                elevation: 30,
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                shadowColor: Colors.teal,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => RegisterPage()));
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.teal, // red as border color
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    height: 50,
                    width: 300,
                    child: Center(
                        child: Text(
                      'ثبت نام',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.teal,
                      ),
                    )),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Material(
                elevation: 30,
                borderRadius: BorderRadius.circular(30),
                color: Colors.teal,
                shadowColor: Colors.teal[300],
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.teal, // red as border color
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    height: 50,
                    width: 300,
                    child: Center(
                        child: Text(
                      'ورود',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
