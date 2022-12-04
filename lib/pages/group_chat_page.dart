import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sports_club/utils/colors.dart';

import '../utils/utils.dart';

class GroupChatPage extends StatefulWidget {
  String gid;
  GroupChatPage(this.gid, {Key? key}) : super(key: key);

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final groupChat = FirebaseFirestore.instance.collection('GroupChat');
  var groupData;
  var data;
  var userData;
  bool isLoading = false;
  final TextEditingController _textController = TextEditingController();

  getGroupChatData() async {
    setState(() {
      isLoading = true;
    });
    var groupChatSnap = await groupChat.doc(widget.gid).get();
    groupData = await groupChatSnap.data();
    setState(() {
      isLoading = false;
    });
  }

  void sendMessage(String msg) async {
    if (msg == '') return;
    await groupChat.doc(widget.gid).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'msg': msg,
      'name': userData['username'],
      'senderPhoto': userData['photoUrl'],
    }).then((value) {
      _textController.text = '';
    });
  }

  bool isSender(String friend) {
    return friend == FirebaseAuth.instance.currentUser!.uid;
  }

  Alignment getAlignment(friend) {
    if (friend == FirebaseAuth.instance.currentUser!.uid) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  getCurrentUserData() async {
    try {
      setState(() {
        isLoading = true;
      });
      //get users document
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      userData = userSnap.data()!;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getGroupChatData();
    getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isLoading ? Container() : Text(groupData['groupName']),
        backgroundColor: appbarColor,
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('GroupChat')
              .doc(widget.gid)
              .collection('messages')
              .orderBy('createdOn', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            return Column(children: [
              Expanded(
                child: ListView(
                  reverse: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    data = document.data()!;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: isSender(data['uid'].toString())?MainAxisAlignment.end:MainAxisAlignment.start,
                        children: [
                          isSender(data['uid'].toString())?Container():CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              data['senderPhoto'],
                            ),
                            radius: 15,
                          ),
                          const SizedBox(width: 10,),
                          Container(
                            //alignment: getAlignment(data['uid'].toString()),
                            // padding: const EdgeInsets.all(10),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.3,
                            ),
                            color: mobileBackgroundColor,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: isSender(data['uid'].toString())
                                      ? Colors.blue
                                      : Colors.green,
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(12)),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  data['msg'],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                          ),
                        ],
                      ),
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
                      decoration:
                          const InputDecoration(labelText: "   Send mesesages"),
                      controller: _textController,
                    ),
                  ),
                  IconButton(
                      onPressed: () => sendMessage(_textController.text),
                      icon: const Icon(
                        Icons.send_rounded,
                        color: appbarColor,
                      ))
                ],
              ),
            ]);
          }),
    );
  }
}
