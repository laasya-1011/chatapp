import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection('users')
        .where('name', isEqualTo: username)
        .getDocuments();
  }

  getUserByUserEmail(String useremail) async {
    return await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: useremail)
        .getDocuments();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection('users').add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatroomId, chatRoomMap) {
    Firestore.instance
        .collection('chatroom')
        .document(chatroomId)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatroomId, messageMap) {
    Firestore.instance
        .collection('chatroom')
        .document(chatroomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatroomId) async {
    return Firestore.instance
        .collection('chatroom')
        .document(chatroomId)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return Firestore.instance
        .collection("chatroom")
        .where('users', arrayContains: userName)
        .snapshots();
  }
}
