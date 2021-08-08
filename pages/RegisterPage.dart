import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:sms_bank_handler/utils/showMySnackBar.dart';
import 'package:sms_bank_handler/pages/LoginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var password1Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'ثبت نام',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: RegisterUI(),
      // bottomNavigationBar: RegisterBottomNav(),
    );
  }

  Widget RegisterUI() {
    return SingleChildScrollView(
      child: Builder(
        builder: (context) => Center(
          child: Column(
            children: [
              SizedBox(
                height: 200,
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
                    controller: password1Controller,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'تکرار رمز ورود',
                      hintStyle: TextStyle(color: Colors.cyan),
                      contentPadding: EdgeInsets.only(right: 20),
                      border: InputBorder.none,
                      icon: Padding(
                        padding: EdgeInsets.only(left: 20, right: 10),
                        child: Icon(
                          Icons.vpn_key_outlined,
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
                      sendRegisterRequest(
                        email: emailController.text,
                        password: passwordController.text,
                        password1: password1Controller.text,
                      );
                    },
                    borderRadius: BorderRadius.circular(40),
                    child: Center(
                      child: Text(
                        'ثبت نام',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlueAccent),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendRegisterRequest(
      {@required String email = '',
      @required String password = '',
      @required String password1 = ''}) async {
    if (email == '') {
      showMySnackBar(context, 'فیلد ایمیل الزامی است!');
    }
    if (password == '') {
      showMySnackBar(context, 'فیلد رمز ورود الزامی است!');
    }
    if (password1 == '') {
      showMySnackBar(context, 'لطفا رمز ورود خود را با تکرار آن تایید کنید!');
    }
    if (password != password1) {
      showMySnackBar(context, 'رمز ورود خود را درست تکرار نکرده اید!');
    }

    ////////////////////// START: GET TOKEN //////////////////////////
    // var url = Uri.parse('http://ehsanpage.pythonanywhere.com/api/token/');
    // var response = await http.post(
    //   url,
    //   body: {'username': 'MobileApp@ehsan.com', 'password': 'esn13791379'},
    // );

    // var token;
    // var tokenJson = json.decode(utf8.decode(response.bodyBytes));
    //
    // if (response.statusCode == 200 && tokenJson['token'] != null) {
    //   token = tokenJson['token'];
    // } else {
    //   showMySnackBar(context, '1. خطایی در اتصال به سرور رخ داده است.');
    // }
    ////////////////////// END: GET TOKEN //////////////////////////

    ////////////////////// START: CREATE //////////////////////////
    var url = Uri.parse('http://ehsanpage.pythonanywhere.com/api/user-create/');
    var response = await http.post(
      url,
      body: {'email': email, 'password': password},
    );

    var userJson = json.decode(utf8.decode(response.bodyBytes));
    if (!EmailValidator.validate(email)) {
      showMySnackBar(context, 'ایمیل وارد شده نادرست است.');
    } else if (response.statusCode == 400) {
      // already exist
      showMySnackBar(context,
          'قبلا با این ایمیل ثبت نام کرده اید. برای فعال سازی به ایمیل خود مراجعه کنید.');
    } else if (response.statusCode == 201) {
      // acc created but not activate

      showMySnackBar(context,
          'اکانت شما با موفقیت ساخته شد. ایمیل فعال سازی حساب برای شما ارسال شد.');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      // print(response.statusCode);
      // print(response.body);
      // print(userJson['email']);
      // print(userJson['email'].runtimeType);
      // print(userJson['is_active']);

      showMySnackBar(context, '2. خطایی در اتصال به سرور رخ داده است.');
    }
    ////////////////////// END: CREATE //////////////////////////
  }
}

// class RegisterBottomNav extends StatelessWidget {
//   const RegisterBottomNav({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       color: Colors.white,
//       child: Container(
//         decoration: BoxDecoration(
//           boxShadow: [BoxShadow(color: Colors.black)], // insert top border
//           color: Colors.white,
//         ),
//         height: 50,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//                 margin: EdgeInsets.only(left: 10),
//                 child: Row(
//                   children: [
//                     Icon(Icons.arrow_back_ios),
//                     Text(
//                       'بازگشت',
//                       style:
//                           TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
//                     )
//                   ],
//                 )),
//             Container(
//               margin: EdgeInsets.only(right: 10),
//               child: InkWell(
//                 onTap: () {
//                   sendRegisterRequest(
//                       email: emailController.text,
//                       password: passwordController.text);
//                 },
//                 child: Row(
//                   children: [
//                     Text(
//                       'تایید',
//                       style: TextStyle(
//                           color: Colors.cyan,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     Icon(
//                       Icons.arrow_forward_ios,
//                       color: Colors.cyan,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void sendRegisterRequest(
//       {@required String email = '', @required String password = ''}) async {
//     ////////////////////// START: GET TOKEN //////////////////////////
//     var url = Uri.parse('http://127.0.0.1:8000/api/token/');
//     var response = await http.post(url,
//         body: {'email': 'MobileApp@ehsan.com', 'password': 'esn13791379'});
//     var token;
//     if (response.statusCode == 200) {
//       var productJson = json.decode(utf8.decode(response.bodyBytes));
//       token = productJson['token'];
//     } else {
//       //err
//     }
//     ////////////////////// END: GET TOKEN //////////////////////////
//
//     ////////////////////// START: CREATE //////////////////////////
//     url = Uri.parse('http://127.0.0.1:8000/api/user-create/');
//     response = await http.post(url,
//         body: {'email': email, 'password': password},
//         headers: {'Authorization': 'Token ' + token});
//     bool isActive;
//     if (response.statusCode == 200) {
//       var productJson = json.decode(utf8.decode(response.bodyBytes));
//       isActive = productJson['is_active'];
//       showMySnackBar(context, 'ایمیل تایید حساب برای شما ارسال شد.');
//     } else {
//       showMySnackBar(context, 'خطایی رخ داده است.');
//     }
//     ////////////////////// END: CREATE //////////////////////////
//
//     // setState(() {
//     //   var productJson = json.decode(utf8.decode(response.bodyBytes));
//     //   for (var i in productJson) {
//     //     var productItem = Product(i['id'], i['product_name'], i['price'],
//     //         i['image_url'], i['description'], i['off']);
//     //     _items.add(productItem);
//     //   }
//     // });
//   }
//
//   void showMySnackBar(BuildContext context, String message) {
//     Scaffold.of(context).showSnackBar(SnackBar(
//         content: Text(
//       message,
//       style: TextStyle(
//         fontSize: 20,
//       ),
//     )));
//   }
// }
