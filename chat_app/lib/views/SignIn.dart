import 'package:chat_app/helper/helperFunc.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/dataBase.dart';
import 'package:chat_app/views/ChatRoom.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

//import 'SignUp.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn({this.toggle});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  final authMethod = Get.find<AuthMethod>();
  TextEditingController emailID = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  final databaseMethods = Get.find<DatabaseMethods>();
  QuerySnapshot snapshotUserInfo;
  signIn() {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmail(emailID.text);
      setState(() {
        isLoading = true;
      });
      databaseMethods.getUserByUserEmail(emailID.text).then((val) {
        setState(() {
          snapshotUserInfo = val;
        });

        HelperFunctions.saveUserName(
            snapshotUserInfo.documents[0].data['name']);
      });
      authMethod
          .signInWithEmailandPassword(emailID.text, password.text)
          .then((val) {
        // print('$val');

        if (val != null) {
          HelperFunctions.saveUserLoggedIn(true);
          Get.to(ChatRoom());
        }
      }).catchError((e) {
        print(e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff0D0372),
      body: Container(
        width: width,
        height: height,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 60, bottom: 20),
              width: width,
              height: height * 0.392,
              child: Text(
                'Welcome \nTo\nWidleChat !',
                style: GoogleFonts.dancingScript(
                    color: Colors.white,
                    letterSpacing: 1,
                    fontSize: 53,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: TextFormField(
                      validator: (val) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val)
                            ? null
                            : 'Please provide a valid emailID';
                      },
                      controller: emailID,
                      style: TextStyle(color: Colors.white),
                      decoration: textFieldInputDeco('Enter your Email ID'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: TextFormField(
                      validator: (val) {
                        return val.length > 7
                            ? null
                            : 'minimum 8 characters needed ';
                      },
                      controller: password,
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      decoration: textFieldInputDeco('Enter Password'),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: width * 0.3,
              height: height * 0.052,
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(left: 40, right: 10),
              child: TextButton(
                onPressed: () {
                  print('hello');
                },
                //splashColor: Colors.blue[700],
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                //print("Confirm");
                signIn();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    boxShadow: [
                      BoxShadow(color: Colors.blue, offset: Offset(0, 0))
                    ],
                    borderRadius: BorderRadius.circular(20)),
                width: width * 0.6,
                child: Text(
                  'Sign In',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Confirm");
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.white, offset: Offset(0, 0))
                    ],
                    borderRadius: BorderRadius.circular(20)),
                width: width * 0.6,
                child: Text(
                  'Sign In with Google',
                  style: GoogleFonts.poppins(
                      color: Colors.blue[900],
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account?',
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
                ),
                SizedBox(
                  width: 8,
                ),
                TextButton(
                  onPressed: () {
                    //Get.to(SignUp());
                    widget.toggle();
                  },
                  child: Text(
                    'Register now',
                    style: GoogleFonts.poppins(
                        decoration: TextDecoration.underline,
                        fontSize: 13,
                        color: Colors.white),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
