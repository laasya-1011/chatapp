import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/dataBase.dart';
import 'package:chat_app/views/ChatRoom.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final databaseMethods = Get.find<DatabaseMethods>();

  String q = "";
  TextEditingController searchController = TextEditingController();
/*   QuerySnapshot
      searchSnapshot;
  Future initiateSearch({@required String name}) async {
    await databaseMethods.getUserByUsername(name).then((val) {
      setState(() {
        searchSnapshot = val;

        print("doc length: ${searchSnapshot.documents.length}"); // i am closing the ap to test it on previous version okay  ?okay sir
      });
    });
  } */

  createChatRoomAndStartConversation(String username) {
    if (username != Constants.myName) {
      String chatRoomId = getChatroomId(username, Constants.myName);
      List<String> users = [username, Constants.myName];
      Map<String, dynamic> chatroomMap = {
        'users': users,
        'chatroomId': chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatroomMap);
      Get.to(ConversationScreen(chatRoomId));
    } else {
      print('you cannot send message to yourself');
    }
  }

  /*  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.documents.length,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchSnapshot.documents[index].data['name'],
                userEmail: searchSnapshot.documents[index].data['email'], // wait let this sdk install //ok sir// okay
              );
            },
          )
        : Container();
  } */

  Widget searchList() {
    return StreamBuilder(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("No data"),
            );
          } else {
            List<DocumentSnapshot> list = snapshot.data.documents;
            if (q != "") {
              List<DocumentSnapshot> newList = [];

              for (var item in snapshot.data.documents) {
                if (item['name']
                    .toString()
                    .toLowerCase()
                    .contains(q.toLowerCase())) {
                  newList.add(item);
                  print(item['name']);
                } else {
                  print("hello");
                }

                list = newList;
              }
            } else {
              list = snapshot.data.documents;
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return searchTile(
                  userName: list[index].data['name'],
                  userEmail: list[index].data['email'],
                );
              },
            );
          }
        });
  }

  Widget searchTile({String userName, final String userEmail}) {
    return Container(
      child: ListTile(
        title: Text(userName),
        subtitle: Text(userEmail),
        onTap: () {
          createChatRoomAndStartConversation(userName);
        },
      ),
    );
  }

  getChatroomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.black45,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.to(ChatRoom());
            },
          ),
          title: TextField(
            controller:
                searchController, 

            onChanged: (String name) {
              /*    initiateSearch(name: name);
              setState(() {}); */
              q = name;
              setState(
                  () {}); 
            },
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                hintText: 'search...',
                hintStyle: TextStyle(color: Colors.white54)),
          ),
          elevation: 0,
          actions: [
            GestureDetector(
                onTap: () {},
                child: Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.search)))
          ],
        ),
        body: Container(
          width: width,
          height: height,
          child: Container(color: Colors.white, child: searchList()),
        ));
  }
}
