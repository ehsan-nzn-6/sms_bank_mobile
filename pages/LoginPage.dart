import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:sms_bank_handler/pages/RegisterPage.dart';
import 'package:sms_bank_handler/utils/showMySnackBar.dart';
import 'package:sms_bank_handler/MainApp.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import 'dart:async';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'ورود',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: LoginUI(),
      // bottomNavigationBar: RegisterBottomNav(),
    );
  }

  Widget LoginUI() {
    return SingleChildScrollView(
      child: Builder(
        builder: (context) => Center(
          child: Column(
            children: [
              SizedBox(
                height: 160,
              ),
              Container(
                margin: EdgeInsets.only(left: 50, right: 50, top: 10),
                child: Material(
                  borderRadius: BorderRadius.circular(40),
                  shadowColor: Colors.grey[300],
                  elevation: 30,
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'ایمیل',
                      hintStyle: TextStyle(color: Colors.cyan),
                      contentPadding: EdgeInsets.only(right: 20),
                      border: InputBorder.none,
                      icon: Padding(
                        padding: EdgeInsets.only(left: 20, right: 10),
                        child: Icon(
                          Icons.email_rounded,
                          color: Colors.cyan,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 50, right: 50, top: 10),
                child: Material(
                  borderRadius: BorderRadius.circular(40),
                  shadowColor: Colors.grey[300],
                  elevation: 30,
                  child: TextField(
                    textAlign: TextAlign.center,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    style: TextStyle(fontSize: 18),
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'رمز ورود',
                      hintStyle: TextStyle(color: Colors.cyan),
                      contentPadding: EdgeInsets.only(right: 20),
                      border: InputBorder.none,
                      icon: Padding(
                        padding: EdgeInsets.only(left: 20, right: 10),
                        child: Icon(
                          Icons.vpn_key,
                          color: Colors.cyan,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 50, right: 50, top: 10),
                // color: Colors.red,
                height: 50,
                width: 295,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlueAccent),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(40),
                  shadowColor: Colors.lightBlueAccent,
                  elevation: 15,
                  child: InkWell(
                    onTap: () {
                      sendLoginRequest(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                    },
                    borderRadius: BorderRadius.circular(40),
                    child: Center(
                      child: Text(
                        'ورود',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlueAccent),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  child: Text(
                    'اکانت ندارید؟ کلیک کنید.',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        fontSize: 19,
                        color: Colors.green[800],
                        decoration: TextDecoration.underline),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void sendLoginRequest({
    @required String email = '',
    @required String password = '',
  }) async {
    if (email == '') {
      showMySnackBar(context, 'فیلد ایمیل الزامی است!');
    }
    if (password == '') {
      showMySnackBar(context, 'فیلد رمز ورود الزامی است!');
    }

    ////////////////////// START: GET TOKEN //////////////////////////
    var url = Uri.parse('http://ehsanpage.pythonanywhere.com/api/token/');
    var response = await http.post(
      url,
      body: {'username': email, 'password': password},
    );

    var token;
    var tokenJson = json.decode(utf8.decode(response.bodyBytes));

    if (!EmailValidator.validate(email)) {
      showMySnackBar(context, 'ایمیل وارد شده نادرست است.');
    } else if (response.statusCode == 200) {
      token = tokenJson['token'];
      // login
      final storage = new FlutterSecureStorage();
      await storage.write(key: 'token', value: token);
      await storage.write(key: 'email', value: email);
      var userurl = Uri.parse(
          'http://ehsanpage.pythonanywhere.com/api/user-rud/${email}/');
      var userresponse = await http.get(
        userurl,
      );
      var userrespJson = json.decode(utf8.decode(userresponse.bodyBytes));

      await storage.write(key: 'userID', value: userrespJson['id'].toString());

      // Navigator.of(context).pop();
      // Navigator.of(context).pop();
      // Navigator.of(context).pop();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => MainApp()));

      // login
    } else if (response.statusCode == 400) {
      ////////////////////////// START: CHECK IS ACTIVE OR NOT //////////////////////////////////////
      // GET MOBILE TOKEN. TODO: FUNCTIONED
      var checkResponse,
          mobileToken,
          checkUri =
              Uri.parse('http://ehsanpage.pythonanywhere.com/api/token/');
      checkResponse = await http.post(
        checkUri,
        body: {'username': 'MobileApp@ehsan.com', 'password': 'esn13791379'},
      );

      var mobileJson = json.decode(utf8.decode(checkResponse.bodyBytes));
      mobileToken = mobileJson['token'];
      // GET MOBILE TOKEN. TODO: FUNCTIONED

      url = Uri.parse(
          'http://ehsanpage.pythonanywhere.com/api/user-rud/${email}/');
      response = await http
          .get(url, headers: {'Authorization': 'Token ' + mobileToken});

      var userJson = json.decode(utf8.decode(response.bodyBytes));

      if (userJson['is_active'] == false) {
        showMySnackBar(context, 'ایمیل شما فعال نشده است.');
      } else {
        showMySnackBar(context, 'ایمیل یا پسورد خود را اشتباه وارد کرده اید!');
      }
      ////////////////////////// START: CHECK IS ACTIVE OR NOT //////////////////////////////////////
    } else {
      showMySnackBar(context, '1. خطایی در اتصال به سرور رخ داده است.');
    }

    ////////////////////// END: GET TOKEN //////////////////////////

    ////////////////////// START: CREATE //////////////////////////
    // url = Uri.parse('http://ehsanpage.pythonanywhere.com/api/user-rud/${email}/');
    // response = await http.post(url,
    //     body: {'email': email, 'password': password},
    //     headers: {'Authorization': 'Token ' + token});
    //
    // var userJson = json.decode(utf8.decode(response.bodyBytes));
    // bool? isActive;
    // if (!EmailValidator.validate(email)) {
    //   showMySnackBar(context, 'ایمیل وارد شده نادرست است.');
    // } else if (userJson['is_active'] == true) {
    //   // login
    // } else if (userJson['is_active'] == false) {
    //   // print(response.statusCode);
    //   // print(response.body);
    //   // print(userJson['email']);
    //   // print(userJson['email'].runtimeType);
    //   // print(userJson['is_active']);
    //
    //   showMySnackBar(context, 'حساب شما فعال نیست.');
    // }
    ////////////////////// END: CREATE //////////////////////////
  }
}
