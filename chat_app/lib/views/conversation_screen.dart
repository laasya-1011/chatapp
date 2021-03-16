import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/dataBase.dart';
import 'package:chat_app/views/ChatRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'dart:io';

class ConversationScreen extends StatefulWidget {
  final String chatroomId;
  ConversationScreen(this.chatroomId); //
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController textEditingController = TextEditingController();
  final databaseMethods = Get.find<DatabaseMethods>();
  Stream<QuerySnapshot> chatMessageStream;
  QuerySnapshot snapshot;
  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.documents[index].data['message'],
                      isSendByMe: Constants.myName ==
                          snapshot.data.documents[index].data['sendBy']);
                },
              )
            : Center(
                child: Container(
                  child: Text('Can\'t show the messages'),
                ),
              );
      },
    );
  }

  sendMessage() {
    if (textEditingController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': textEditingController.text,
        'sendBy': Constants.myName,
        'time': DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatroomId, messageMap);
      setState(() {
        textEditingController.text = '';
      });
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatroomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(ChatRoom());
          },
        ),
        title: Text(
          widget.chatroomId
              .replaceAll("_", "")
              .replaceAll(Constants.myName, ""),
          style: GoogleFonts.raleway(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal),
        ),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white30,
        width: width,
        height: height,
        // padding: EdgeInsets.only(bottom: 8),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 48.0),
              child: chatMessageList(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: width,
                height: height * 0.08,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 0), color: Colors.blueGrey[400]),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            hintText: 'Message...',
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          print('send');
                          sendMessage();
                        },
                        child: Container(
                            width: width * 0.12,
                            height: height * 0.09,
                            margin: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[350],
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 0),
                                    color: Colors.blueGrey[400]),
                              ],
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.send_sharp,
                              color: Colors.white,
                            )))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile({this.message, this.isSendByMe});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: isSendByMe ? 0 : 24,
          right: isSendByMe ? 24 : 0),
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin: isSendByMe
              ? EdgeInsets.only(left: 30)
              : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(top: 13, bottom: 13, left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: isSendByMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomLeft: Radius.circular(23))
                  : BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomRight: Radius.circular(23)),
              gradient: LinearGradient(
                colors: isSendByMe
                    ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                    : [const Color(0xff00FF00), const Color(0xff01DF01)],
              )),
          child: Text(message,
              textAlign: TextAlign.start,
              style: GoogleFonts.poppins(fontSize: 17, color: Colors.black))),
    );
  }
}
