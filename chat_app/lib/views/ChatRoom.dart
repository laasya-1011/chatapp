import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperFunc.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/dataBase.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final authMethod = Get.find<AuthMethod>(); // get that screen
  final databaseMethods = Get.find<DatabaseMethods>();
  Stream chatRooms;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data.documents[index].data['chatroomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId:
                        snapshot.data.documents[index].data["chatroomId"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserName();
    DatabaseMethods().getChatRooms(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              authMethod.signOut();
              Get.to(Authenticate());
            },
          ),
          title: Text(
            'WidleChat',
            style: GoogleFonts.dancingScript(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.normal),
          ),
          elevation: 0,
          actions: [
            GestureDetector(
              onTap: () {
                Get.to(Search());
              },
              child: Container(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.search),
              ),
            ),
            GestureDetector(
              onTap: () {
                return showDialog(
                    context: context,
                    builder: (_) {
                      return PopScreen(); // where is conversation screen
                    });
              },
              child: Container(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.more_vert),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(Search());
          },
          child: Icon(Icons.message),
        ),
        body: Container(child: chatRoomsList()));
  }
}

class PopScreen extends StatefulWidget {
  @override
  _PopScreenState createState() => _PopScreenState();
}

class _PopScreenState extends State<PopScreen> {
  final authMethod = Get.find<AuthMethod>();
  // List<String> set = ['Settings', 'Log Out'];
  // int _sel;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Container(
      // decoration: BoxDecoration(backgroundBlendMode: BlendMode.clear),
      alignment: Alignment.topRight,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(top: 24, right: 10),
      child: Material(
        type: MaterialType.transparency,
        child: Container(
            alignment: Alignment.topRight,
            width: width * 0.35,
            height: height * 0.112,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                    topRight: Radius.zero)),
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    //print('tapped');
                    Get.to(Settings());
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                      child: Text(
                        'Settings',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      )),
                ),
                Divider(
                  color: Colors.black45,
                ),
                GestureDetector(
                  onTap: () {
                    print('tapped');
                    authMethod.signOut();
                    Get.to(Authenticate());
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                      child: Text(
                        'Log Out',
                        style: GoogleFonts.poppins(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      )),
                )
              ],
            )),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ConversationScreen(chatRoomId));
      },
      child: Container(
        //color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w500)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400))
          ],
        ),
      ),
    );
  }
}
