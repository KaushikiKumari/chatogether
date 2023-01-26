// ignore_for_file: unnecessary_null_comparison, no_leading_underscores_for_local_identifiers

import 'package:chatogether/helper/auth_method.dart';
import 'package:chatogether/pages/dashboard/chat_room.dart';
import 'package:chatogether/widgets/change_theme_button_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("name", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      if (kDebugMode) {
        print(userMap);
      }
    });
  }

  void setStatus(String status) async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({"status": status});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      //online
      setStatus("Online");
    } else {
      //offline
      setStatus("Offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text('chaTogether',
            style: TextStyle(
                color: Theme.of(context).iconTheme.color,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        actions: [
          const ChangeThemeButtonWidget(),
          IconButton(
              onPressed: () {
                logOut(context);
              },
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).iconTheme.color,
              )),
        ],
      ),
      body: Column(
        children: [
          userMap != null
              ? ListTile(
                  onTap: () {
                    String roomId = chatRoomId(
                        _auth.currentUser!.displayName!, userMap!['name']);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatRoom(
                          chatRoomId: roomId,
                          userMap: userMap!,
                        ),
                      ),
                    );
                  },
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).iconTheme.color,
                      ),
                      const Positioned(
                        top: 2,
                        right: 1,
                        child: CircleAvatar(
                            radius: 5, backgroundColor: Colors.green),
                      )
                    ],
                  ),
                  title: Text(
                    userMap!['name'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(userMap!['email']),
                  trailing: Icon(
                    Icons.chat,
                    color: Theme.of(context).iconTheme.color,
                  ),
                )
              : Container(),
          isLoading
              ? Center(
                  // ignore: sized_box_for_whitespace
                  child: Container(
                    height: size.height / 20,
                    width: size.width / 20,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _searchTextField(),
                      userMap != null
                          ? ListTile(
                              onTap: () {
                                String roomId = chatRoomId(
                                    _auth.currentUser!.displayName!,
                                    userMap!['name']);

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ChatRoom(
                                      chatRoomId: roomId,
                                      userMap: userMap!,
                                    ),
                                  ),
                                );
                              },
                              leading: Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).iconTheme.color,
                                  ),
                                  const Positioned(
                                    top: 2,
                                    right: 1,
                                    child: CircleAvatar(
                                        radius: 5,
                                        backgroundColor: Colors.green),
                                  )
                                ],
                              ),
                              title: Text(
                                userMap!['name'],
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(userMap!['email']),
                              trailing: Icon(
                                Icons.chat,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  _searchTextField() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Center(
          child: TextField(
            textAlign: TextAlign.left,
            textAlignVertical: TextAlignVertical.center,
            controller: _search,
            decoration: InputDecoration(
              fillColor: Theme.of(context).primaryColor,
              filled: true,
              hintText: 'Search the user via email',
              contentPadding: const EdgeInsets.only(left: 20, top: 5),
              suffixIcon: IconButton(
                  onPressed: onSearch,
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).iconTheme.color,
                  )),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _chatList() async {
    final friends = (await FirebaseFirestore.instance
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .get())
        .data;
  }
}
