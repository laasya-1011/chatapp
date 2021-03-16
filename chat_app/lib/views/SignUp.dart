import 'package:chat_app/helper/helperFunc.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/dataBase.dart';
import 'package:chat_app/views/ChatRoom.dart';

import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp({this.toggle});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  TextEditingController userName = TextEditingController();
  TextEditingController emailID = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  final authMethod = Get.find<AuthMethod>();
  final databaseMethods = Get.find<DatabaseMethods>();

  signMeUp() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        'name': userName.text,
        'email': emailID.text
      };
      HelperFunctions.saveUserName(userName.text);
      HelperFunctions.saveUserEmail(emailID.text);
      setState(() {
        isLoading = true;
      });

      authMethod
          .signUpWithEmailandPassword(emailID.text, password.text)
          .then((val) {
        // print('$val');
        if (val != null) {
          databaseMethods.uploadUserInfo(userInfoMap);
          HelperFunctions.saveUserLoggedIn(true);
          Get.to(ChatRoom());
        }
      }).catchError((e) {
        print(e.toString());
      });
      /* setState(() {
      isLoading = false;
    });*/
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff040448),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            )
          : Container(
              width: width,
              height: height,
              child: ListView(
                children: [
                  Container(
                    width: width,
                    height: height * 0.32,
                    padding: EdgeInsets.only(top: 60),
                    child: Text(
                      'SignUp \nNow!',
                      style: GoogleFonts.dancingScript(
                          color: Colors.white,
                          letterSpacing: 1,
                          fontSize: 50,
                          fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: TextFormField(
                            validator: (val) {
                              return val.length > 2
                                  ? null
                                  : 'Please provide a valid username';
                            },
                            style: TextStyle(color: Colors.white),
                            controller: userName,
                            decoration: textFieldInputDeco('Enter Username'),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : 'Please provide a valid emailID';
                            },
                            style: TextStyle(color: Colors.white),
                            controller: emailID,
                            decoration: textFieldInputDeco('Enter Email ID'),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return val.length > 7
                                  ? null
                                  : 'minimum 8 characters needed ';
                            },
                            style: TextStyle(color: Colors.white),
                            controller: password,
                            decoration: textFieldInputDeco('Enter Password'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      signMeUp();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      margin:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          boxShadow: [
                            BoxShadow(color: Colors.blue, offset: Offset(0, 0))
                          ],
                          borderRadius: BorderRadius.circular(20)),
                      width: width * 0.6,
                      child: Text(
                        'Sign Up',
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
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (BuildContext context) => SecondScreen()));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      margin:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.white, offset: Offset(0, 0))
                          ],
                          borderRadius: BorderRadius.circular(20)),
                      width: width * 0.6,
                      child: Text(
                        'Sign Up with Google',
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
                        'Already have an account?',
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: Colors.white),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      TextButton(
                        onPressed: () {
                          //Get.back();
                          widget.toggle();
                        },
                        child: Text(
                          'Login now',
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
