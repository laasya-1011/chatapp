import 'dart:io';

import 'package:chat_app/helper/constants.dart';
//import 'package:chat_app/helper/helperFunc.dart';
import 'package:chat_app/services/dataBase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  File _image;
  int index;
  QuerySnapshot snapshot;
  final databaseMethods = Get.find<DatabaseMethods>();
  Future getImage() async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: ImgSource.Both,
      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ),
    );
    setState(() {
      _image = image;
    });
  }

  getEmailInfo() async {
    databaseMethods.getUserByUsername(Constants.myName).then((val) {
      setState(() {
        snapshot = val;
      });
    });
    Constants.myEmail = await snapshot.documents[index].data['email'];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .where("name", isEqualTo: Constants.myName)
                .limit(1)
                .snapshots(),
            builder: (context, snapshot) {
              // show your firebase
              return ListView(
                children: [
                  Center(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                      width: width * 0.3,
                      height: width * 0.3,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _image == null
                                  ? AssetImage(
                                      'assets/images/chat.jpeg',
                                    )
                                  : FileImage(
                                      _image,
                                    )),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blue,
                                blurRadius: 2,
                                offset: Offset(0, 0))
                          ]),
                    ),
                  ),
                  GestureDetector(
                    onTap: getImage,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(horizontal: width * 0.44),
                      width: 10,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                      height: 80,
                      color: Colors.blue[100],
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 28),
                      child: Row(
                        children: [
                          Text('UserName :',
                              style: GoogleFonts.raleway(
                                  fontSize: 18, color: Colors.black45)),
                          SizedBox(
                            width: 20,
                          ),
                          Text(snapshot.data.documents[0]['name'],
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: Colors.black))
                        ],
                      )),
                  Container(
                      height: 80,
                      color: Colors.blue[100],
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 18),
                      child: Row(
                        children: [
                          Text('Email :',
                              style: GoogleFonts.raleway(
                                  fontSize: 18, color: Colors.black45)),
                          SizedBox(
                            width: 20,
                          ),
                          Text(snapshot.data.documents[0]['email'],
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: Colors.black))
                        ],
                      )),
                ],
              );
            }),
      ),
    );
  }
}
