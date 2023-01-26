// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatRoom extends StatelessWidget {
  final Map<String, dynamic> userMap;
  final String chatRoomId;

  ChatRoom({super.key, required this.chatRoomId, required this.userMap});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.displayName,
        "message": _message.text,
        "time": FieldValue.serverTimestamp(),
      };
      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      if (kDebugMode) {
        print("Enter some text");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: StreamBuilder<DocumentSnapshot>(
          stream:
              _firestore.collection("users").doc(userMap['uid']).snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userMap['name']),
                  Text(snapshot.data!['status']),
                ],
              ));
            } else {
              return Container();
            }
          }),
        ),
      ),
      body: SingleChildScrollView(
        //physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
                height: size.height / 1.30,
                width: size.width / 1,
                child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('chatroom')
                        .doc(chatRoomId)
                        .collection('chats')
                        .orderBy("time", descending: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data != null) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(5.0, 5.0, 15.0, 0),
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              //shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> map =
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>;
                                return Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: messageCard(context, map, size),
                                );
                              }),
                        );
                      } else {
                        return Container();
                      }
                    })),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  height: size.height / 10,
                  width: size.width / 1,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width / 1.25,
                        height: 50,
                        child: Center(
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            textAlign: TextAlign.left,
                            textAlignVertical: TextAlignVertical.center,
                            controller: _message,
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).primaryColor,
                              filled: true,
                              hintText: 'Type your message here...',
                              contentPadding:
                                  const EdgeInsets.only(left: 20, top: 5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                            ),
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: const Color.fromARGB(255, 28, 42, 79),
                        child: Center(
                          child: IconButton(
                              onPressed: onSendMessage,
                              icon: const Icon(Icons.send,
                                  size: 18, color: Colors.white)),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageCard(
      BuildContext context, Map<String, dynamic> map, Size size) {
    return Container(
      width: size.width / 2,
      alignment: map['sendby'] == _auth.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          color: map['sendby'] == _auth.currentUser!.displayName
              ? const Color.fromARGB(255, 83, 199, 87)
              : const Color.fromARGB(255, 81, 171, 171),
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(15),
              bottomLeft: map['sendby'] == _auth.currentUser!.displayName
                  ? const Radius.circular(15)
                  : const Radius.circular(0),
              topRight: const Radius.circular(15),
              bottomRight: map['sendby'] == _auth.currentUser!.displayName
                  ? const Radius.circular(0)
                  : const Radius.circular(15)),
        ),
        child: Text(map['message'],
            style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: 15,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}
