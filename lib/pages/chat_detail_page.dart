import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sports_club/resources/auth_methods.dart';
import 'package:sports_club/utils/colors.dart';

class ChatDetailPage extends StatefulWidget {
  final friendUid;
  final friendName;
  const ChatDetailPage(
      {Key? key, required this.friendUid, required this.friendName})
      : super(key: key);

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  var chatDocId;
  final TextEditingController _textController = TextEditingController();
  var data;
  bool isLoading = false;
  bool isLoadingM = false;
  var userData = {};

  getUserData() async {
    setState(() {
      isLoading = true;
    });
    //get users document
    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();

    userData = userSnap.data()!;
    setState(() {
      isLoading = false;
    });
    getChatDocId();
  }

  getChatDocId() async {
    setState(() {
      isLoadingM = true;
    });
    await chats
        .where('users',
            isEqualTo: {widget.friendUid: null, currentUserId: null})
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) async {
          if (querySnapshot.docs.isNotEmpty) {
            chatDocId = querySnapshot.docs.single.id;
          } else {
            await chats.add({
              'users': {
                currentUserId: null,
                widget.friendUid: null,
              },
              'names': {
                currentUserId: userData['username'],
                widget.friendUid: widget.friendName,
              }
            }).then((value) => {chatDocId = value});
          }
        })
        .catchError((error) {});

    setState(() {
      isLoadingM = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void sendMessage(String msg) async {
    if (msg == '') return;
    await chats.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uid': currentUserId,
      'friendName': widget.friendName,
      'msg': msg
    }).then((value) {
      _textController.text = '';
    });
  }

  bool isSender(String friend) {
    return friend == currentUserId;
  }

  Alignment getAlignment(friend) {
    if (friend == currentUserId) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(color: primaryColor),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: appbarColor,
              title: Text(
                widget.friendName,
              ),
              centerTitle: true,
            ),
            body: isLoadingM?Container():StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatDocId)
                  .collection('messages')
                  .orderBy('createdOn', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Something went wrong!"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        reverse: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          data = document.data()!;
                          return Container(
                            alignment: getAlignment(data['uid'].toString()),
                            padding: const EdgeInsets.all(10),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.3,
                            ),
                            color: mobileBackgroundColor,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: isSender(data['uid'].toString())
                                      ? Colors.blue
                                      : Colors.green,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16)),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  data['msg'],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                          );
                        }).toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                                labelText: "   Send mesesages"),
                            controller: _textController,
                          ),
                        ),
                        IconButton(
                            onPressed: () => isLoadingM
                                ? () {}
                                : sendMessage(_textController.text),
                            icon: const Icon(
                              Icons.send_rounded,
                              color: appbarColor,
                            ))
                      ],
                    ),
                  ],
                );
              },
            ),
          );
  }
}
