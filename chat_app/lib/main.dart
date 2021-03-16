import 'dart:async';
import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/helperFunc.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/dataBase.dart';
import 'package:chat_app/views/ChatRoom.dart';
//import 'package:chat_app/views/SignUp.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:chat_app/views/SignIn.dart';t
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color(0xff0A0390)),
      home: Screen(),
    );
  }
}

class Screen extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  bool userLoggedIn = false;
  getLoggedInState() async {
    await HelperFunctions.getUserLoggedIn().then((val) {
      setState(() {
        userLoggedIn = val;
      });
    });
  }

  final authMethod = Get.put(AuthMethod());
  final databasemethods = Get.put(DatabaseMethods());
  @override
  void initState() {
    getLoggedInState();
    super.initState();
    Timer(Duration(seconds: 4), () {
      Get.off(userLoggedIn != null ? ChatRoom() : Authenticate());
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
          width: width,
          height: height,
          child: ListView(
            children: [
              Container(
                  width: width,
                  height: height * 0.45,
                  padding: EdgeInsets.fromLTRB(10, 120, 10, 20),
                  child:
                      ClipOval(child: Image.asset('assets/images/widle.png'))),
              Text(
                'Connecting People',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 17),
              ),
              SizedBox(
                height: height * 0.33,
              ),
              Text(
                'FROM\n',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
              Text(
                'Widle Studio'.toUpperCase(),
                style: GoogleFonts.courgette(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2),
                textAlign: TextAlign.center,
              )
            ],
          )),
    );
  }
}

// setVisited() async {
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   preferences.setBool('alreadyVisited', true);
// }

// getVisited() async {
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   bool alreadyVisited = preferences.getBool('alreadyVisited') ?? false;
//   return alreadyVisited;
// }
//  bool visitFlag = await getVisited();
//       setVisited();
//       if (visitFlag == true) {
//         Get.toNamed('/home');
//       } else {
//         Get.toNamed('/signup');
//       }
