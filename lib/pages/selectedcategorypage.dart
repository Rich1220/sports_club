// 選擇想要參加的運動框框之後
// 會顯示時間 校區 一些活動資訊
// import 'dart:html';

// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_club/pages/group_chat_page.dart';
import 'package:sports_club/pages/home_page.dart';
import 'package:sports_club/pages/profile_page.dart';
import 'package:sports_club/resources/firestore_methods.dart';
import 'package:sports_club/utils/colors.dart';

import '../utils/utils.dart';

class SelectedCategoryPage extends StatefulWidget {
  String image_name;
  String name;
  String time;
  String location;
  String sport;
  String whopost;
  String uid;
  String introduce;
  String limitnum;
  List joinList;

  SelectedCategoryPage(
      this.image_name,
      this.name,
      this.time,
      this.location,
      this.sport,
      this.whopost,
      this.uid,
      this.introduce,
      this.limitnum,
      this.joinList,
      {Key? key})
      : super(key: key);

  @override
  State<SelectedCategoryPage> createState() => _SelectedCategoryPageState();
}

class _SelectedCategoryPageState extends State<SelectedCategoryPage> {
  //SelectedCategoryPage(String imgName);
  var activtyData = {};
  var userData = {};
  bool cmdtext = false;
  bool coloron = false;
  bool isLoading = false;
  String photoUrl = "";

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfParticipate(FirebaseAuth.instance.currentUser!.uid, widget.uid);
    getData();
  }

  @override
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteActivity(String uid) async {
    try {
      await _firestore.collection('Users').doc(uid).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  Future<void> checkIfParticipate(String uid, String activityID) async {
    DocumentSnapshot snap =
        await _firestore.collection('Users').doc(activityID).get();
    List joinlist = await (snap.data()! as dynamic)['joinlist'];
    if (joinlist.contains(uid)) {
      print(1);

      if (mounted) {
        setState(() {
          cmdtext = true;
          coloron = true;
        });
      }
    } else {
      print(2);
      if (mounted) {
        setState(() {
          cmdtext = false;
          coloron = false;
        });
      }
    }
  }

  getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      //get users document
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.whopost)
          .get();
      var activitySnap = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;
      activtyData = activitySnap.data()!;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<String> getPhotoUrl(String uid) async {
    isLoading = true;

    var user = await _firestore.collection("users").doc(uid).get();
    var userUrl = user.data()!;

    isLoading = false;

    return userUrl['photoUrl'];
  }

  createGroupChat() async {
    await FirebaseFirestore.instance
        .collection('GroupChat')
        .doc(widget.uid)
        .set({
      "gid": widget.uid,
      "groupName": widget.name,
      "last_message": "",
      "last_message_time": "",
    });
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => GroupChatPage(widget.uid)));
  }

  CheckIfGroupChat() async {
    await FirebaseFirestore.instance
        .collection('GroupChat')
        .doc(widget.uid)
        .get()
        .then(
      (DocumentSnapshot snapshot) {
        if (!snapshot.exists) {
          createGroupChat();
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GroupChatPage(widget.uid)));
        }
      },
    );
  }

  refresh() {
    setState(() {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    // checkIfParticipate(FirebaseAuth.instance.currentUser!.uid,widget.uid);
    // It will provide us total height and width
    Size size = MediaQuery.of(context).size;
    int people = int.parse(widget.limitnum);

    // coloron = cmdtext;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appbarColor,
          title: const Text('活動資訊'),
          centerTitle: true,
          actions: [
            isLoading
                ? Container()
                : activtyData['joinlist']
                            .contains(FirebaseAuth.instance.currentUser!.uid) ||
                        activtyData['whopost'] ==
                            FirebaseAuth.instance.currentUser!.uid
                    ? IconButton(
                        onPressed: () {
                          CheckIfGroupChat();
                        },
                        icon: const Icon(Icons.chat_bubble_outline))
                    : Container(),
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          child: Stack(children: <Widget>[
            Column(children: [
              // Container(
              //   height: size.height * 0.4 - 20,
              //   child: Image.network(widget.image_name),
              // ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 370,
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.image_name))),
              ),
              // Container(
              //   decoration: const BoxDecoration(
              //     color: Colors.white,
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  const Text(
                    "舉辦人 :",
                    style: TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 10),
                  isLoading
                      ? Container()
                      : CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            userData['photoUrl'],
                          ),
                          radius: 18),
                  const SizedBox(
                    width: 5,
                  ),
                  isLoading
                      ? Container()
                      : Text(
                          userData['username'],
                          style: TextStyle(fontSize: 30),
                        ),
                ],
              ),
              buildIntro(widget.introduce),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Text("目前人員: ", style: TextStyle(fontSize: 20)),
                  Container(
                    width: 200,
                    height: 30,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.joinList.length,
                      itemBuilder: ((context, index) {
                        // getPhotoUrl(widget.joinList[index]).then((value) {
                        //   photoUrl = value;
                        // });
                        // print(photoUrl);
                        // return buildAvatar(photoUrl);
                        return FutureBuilder(
                          future: _firestore
                              .collection("users")
                              .doc(widget.joinList[index])
                              .get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator(
                                color: Colors.white,
                              );
                            }
                            return GestureDetector(
                              onTap: (snapshot.data! as dynamic)['uid'] ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? null
                                  : () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage(
                                              uid: (snapshot.data!
                                                  as dynamic)['uid']))),
                              child: buildAvatar(
                                  (snapshot.data! as dynamic)['photoUrl']),
                            );
                          },
                        );
                      }),
                    ),
                  )
                ],
              ),

              // Row(children: [
              //   Row(
              //     // 運動類別icon+文字
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: <Widget>[
              //       const SizedBox(
              //         width: 40,
              //       ),
              //       const Icon(
              //         Icons.sports_baseball_outlined,
              //         color: Colors.orange,
              //         size: 50.0,
              //       ),
              //       Text(
              //         widget.sport,
              //         style:
              //             const TextStyle(fontSize: 31, color: Colors.orange),
              //       ),
              //     ],
              //   ),
              // ]),
              // const SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   // 地點類別
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: <Widget>[
              //     const Icon(
              //       Icons.location_on,
              //       color: Colors.black,
              //       size: 50.0,
              //     ),
              //     Text(
              //       widget.location, // 多加一個空格
              //       style: const TextStyle(fontSize: 31),
              //     )
              //   ],
              // ),
              // Row(
              //   // 時間類別
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: <Widget>[
              //     const Icon(
              //       Icons.access_time_outlined,
              //       color: Colors.black,
              //       size: 50.0,
              //     ),
              //     Text(
              //       widget.time, // 多加一個空格
              //       style: const TextStyle(fontSize: 31),
              //     )
              //   ],
              // ),
              /*Row(
                // 參加人數類別
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  <Widget>[
                  Icon(
                    Icons.person,
                    color: Colors.black,
                    size: 50.0,
                  ),
                  Text(
                    " 5人",
                    style: TextStyle(fontSize: 31.0),
                  )
                ],
              ),*/
              /*Row(
                // 想參加的使用者類別
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  <Widget>[
                  Text(
                    " 想參加人員:",
                    style: TextStyle(fontSize: 31.0),
                  ),
                  Icon(
                    Icons.account_circle,
                    color: Colors.black,
                    size: 50.0,
                  ),
                  Icon(
                    Icons.account_circle,
                    color: Colors.black,
                    size: 50.0,
                  ),
                  Icon(
                    Icons.account_circle,
                    color: Colors.black,
                    size: 50.0,
                  ),
                ],
              ),*/
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: 300.0,
                  height: 50.0,
                  child: FirebaseAuth.instance.currentUser!.uid ==
                          widget.whopost
                      ? RaisedButton(
                          onPressed: () {
                            showAlertDialog(context);
                          },
                          color: Colors.blue,
                          child: const Text(
                            "刪除活動",
                            style: TextStyle(fontSize: 25),
                          ),
                        )
                      : widget.joinList.length == people
                          ? widget.joinList.contains(
                                  FirebaseAuth.instance.currentUser!.uid)
                              ? RaisedButton(
                                  onPressed: () {
                                    FirestoreMethods().participate(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        widget.uid);
                                    setState(() {
                                      cmdtext = !cmdtext;
                                      coloron = !coloron;
                                    });
                                    refresh();
                                  },
                                  color: coloron ? Colors.grey : appbarColor,
                                  child: cmdtext
                                      ? const Text(
                                          "已參加",
                                          style: TextStyle(fontSize: 25),
                                        )
                                      : const Text(
                                          "我要參加",
                                          style: TextStyle(fontSize: 25),
                                        ),
                                )
                              : Container()
                          : RaisedButton(
                              onPressed: () {
                                FirestoreMethods().participate(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    widget.uid);
                                setState(() {
                                  cmdtext = !cmdtext;
                                  coloron = !coloron;
                                });
                                refresh();
                              },
                              color: coloron ? Colors.grey : appbarColor,
                              child: cmdtext
                                  ? const Text(
                                      "已參加",
                                      style: TextStyle(fontSize: 25),
                                    )
                                  : const Text(
                                      "我要參加",
                                      style: TextStyle(fontSize: 25),
                                    ),
                            ))
            ])
          ]),
        ));
  }

  joinactivity() async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.uid)
        .update({"joinlist": getMyData()});
    print(getMyData());
  }

  getMyData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    String whopostname = userDoc.get('username');
    print(whopostname);
    return whopostname;
  }

  void showAlertDialog(BuildContext context) {
    // Init
    AlertDialog dialog = AlertDialog(
      title: const Text("你確定要刪除本篇活動嗎?"),
      actions: [
        ElevatedButton(
            child: const Text("確定"),
            onPressed: () {
              deleteActivity(widget.uid); //刪除活動
              Navigator.pop(context);
            }),
        ElevatedButton(
            child: const Text("取消"),
            onPressed: () {
              Navigator.pop(context);
            }),
      ],
    );
    // Show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  Widget buildIntro(intro) => Container(
      height: 200,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(width: 1, color: Colors.black)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [
            Text(
              "活動介紹:",
              style: TextStyle(fontSize: 25),
            )
          ]),
          Text(
            intro,
            style: const TextStyle(fontSize: 25, height: 1.4),
          ),
        ],
      ));

  Widget buildAvatar(String photoUrl) => CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(
          photoUrl,
        ),
        radius: 25,
      );
}
