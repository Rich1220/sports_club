// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sports_club/pages/calendar_page.dart';
import 'package:sports_club/pages/chat_detail_page.dart';
import 'package:sports_club/pages/edit_profile_page.dart';
import 'package:sports_club/pages/expired_activity.dart';
import 'package:sports_club/pages/login_page.dart';
import 'package:sports_club/pages/my_activity.dart';
import 'package:sports_club/pages/my_upcoming_activity.dart';
import 'package:sports_club/resources/auth_methods.dart';
import 'package:sports_club/utils/colors.dart';
import 'package:sports_club/widgets/follow_button.dart';

import '../helpers/utils.dart';
import '../resources/firestore_methods.dart';
import '../utils/utils.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  int x = 0;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void callChatDetailPage(BuildContext context, String name, String uid) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ChatDetailPage(friendUid: uid, friendName: name)));
  }

  getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      //get users document
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      //get post length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }
  

  void goback(dynamic value) async {
    getData();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
                backgroundColor: appbarColor,
                title: Center(
                  child: FirebaseAuth.instance.currentUser!.uid == widget.uid
                      ? const Text("個人頁面")
                      : Text(
                          // userData['username'],
                          '${userData['username']}的個人頁面',
                        ),
                ),
                centerTitle: true,
                leading: FirebaseAuth.instance.currentUser!.uid == widget.uid
                    ? IconButton(
                        onPressed: () async {
                          await FirestoreMethods().createEvent(
                              FirebaseAuth.instance.currentUser!.uid);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => calendarPage()));
                        },
                        icon: Icon(Icons.calendar_month))
                    : null,
                actions: FirebaseAuth.instance.currentUser!.uid == widget.uid
                    ? [
                        IconButton(
                            onPressed: () async {
                              await AuthMethods().signOut();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                            },
                            icon: const Icon(Icons.logout))
                      ]
                    : [
                        IconButton(
                            onPressed: () => callChatDetailPage(
                                context, userData['username'], userData['uid']),
                            icon: const Icon(Icons.messenger_outline)),
                      ]),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(children: [
                    // Container(
                    //   height: 5,
                    // ),
                    Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                          userData['photoUrl'],
                        ),
                        radius: 60,
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     CircleAvatar(
                    //       backgroundColor: Colors.grey,
                    //       backgroundImage: NetworkImage(
                    //         userData['photoUrl'],
                    //       ),
                    //       radius: 40,
                    //     ),
                    //     // Expanded(
                    //     //   flex: 1,
                    //     //   child: Column(
                    //     //     children: [
                    //     //       Row(
                    //     //         mainAxisSize: MainAxisSize.max,
                    //     //         mainAxisAlignment:
                    //     //             MainAxisAlignment.spaceEvenly,
                    //     //         children: [
                    //     //           buildStateColumn(postLen, "posts"),
                    //     //           buildStateColumn(followers, "followers"),
                    //     //           buildStateColumn(following, "following"),
                    //     //         ],
                    //     //       ),
                    //     //       Row(
                    //     //         mainAxisAlignment:
                    //     //             MainAxisAlignment.spaceEvenly,
                    //     //         children: [
                    //     //           FirebaseAuth.instance.currentUser!.uid ==
                    //     //                   widget.uid
                    //     //               ? FollowButton(
                    //     //                   backgroundColor:
                    //     //                       mobileBackgroundColor,
                    //     //                   borderColor: Colors.grey,
                    //     //                   text: 'Sign Out',
                    //     //                   textColor: primaryColor,
                    //     //                   function: () async {
                    //     //                     await AuthMethods().signOut();
                    //     //                     Navigator.of(context)
                    //     //                         .pushReplacement(
                    //     //                             MaterialPageRoute(
                    //     //                                 builder: (context) =>
                    //     //                                     const LoginPage()));
                    //     //                   })
                    //     //               : isFollowing
                    //     //                   ? FollowButton(
                    //     //                       backgroundColor: Colors.white,
                    //     //                       borderColor: Colors.grey,
                    //     //                       text: 'Unfollow',
                    //     //                       textColor: Colors.black,
                    //     //                       function: () async {
                    //     //                         // await FirestoreMethods()
                    //     //                         ////   .followUser(
                    //     //                         //       FirebaseAuth.instance
                    //     //                         //           .currentUser!.uid,
                    //     //                         //       userData['uid']);

                    //     //                         setState(() {
                    //     //                           isFollowing = false;
                    //     //                           followers--;
                    //     //                         });
                    //     //                       })
                    //     //                   : FollowButton(
                    //     //                       backgroundColor: Colors.blue,
                    //     //                       borderColor: Colors.blue,
                    //     //                       text: 'Follow',
                    //     //                       textColor: Colors.white,
                    //     //                       function: () async {
                    //     //                         //   await FirestoreMethods()
                    //     //                         //        .followUser(
                    //     //                         //           FirebaseAuth.instance
                    //     //                         //               .currentUser!.uid,
                    //     //                         //           userData['uid']);
                    //     //                         //   setState(() {
                    //     //                         //    isFollowing = true;
                    //     //                         //      followers++;
                    //     //                         //   }
                    //     //                         //  );
                    //     //                       })
                    //     //         ],
                    //     //       ),
                    //     //     ],
                    //     //   ),
                    //     // ),
                    //   ],
                    // ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 15),
                      child: Center(
                        child: Text(userData['username'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Container(
                      height: 5,
                    ),
                    // Container(
                    //   //alignment: Alignment.centerLeft,
                    //   padding: const EdgeInsets.only(top: 1),
                    //   child: Center(
                    //     child: Text(
                    //       userData['bio'],
                    //       style: TextStyle(
                    //         fontSize: 20
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FirebaseAuth.instance.currentUser!.uid == widget.uid
                            ? FollowButton(
                                backgroundColor: mobileBackgroundColor,
                                borderColor: Colors.grey,
                                text: 'Edit Profile',
                                textColor: primaryColor,
                                function: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => editPorfilePage(
                                              userUrl: userData['photoUrl'],
                                              userName: userData['username'],
                                              userAbout:
                                                  userData['bio']))).then(
                                      (value) {
                                    goback(value);
                                  });
                                })
                            : Container(),

                        // : isFollowing
                        //     ? FollowButton(
                        //         backgroundColor: Colors.white,
                        //         borderColor: Colors.grey,
                        //         text: 'Unfollow',
                        //         textColor: Colors.black,
                        //         function: () async {
                        //           await FirestoreMethods().followUser(
                        //               FirebaseAuth
                        //                   .instance.currentUser!.uid,
                        //               userData['uid']);

                        //           setState(() {
                        //             isFollowing = false;
                        //             followers--;
                        //           });
                        //         })
                        //     : FollowButton(
                        //         backgroundColor: Colors.blue,
                        //         borderColor: Colors.blue,
                        //         text: 'Follow',
                        //         textColor: Colors.white,
                        //         function: () async {
                        //           await FirestoreMethods().followUser(
                        //               FirebaseAuth
                        //                   .instance.currentUser!.uid,
                        //               userData['uid']);
                        //           setState(() {
                        //             isFollowing = true;
                        //             followers++;
                        //           });
                        //         })
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    buildAbout(userData['bio']),
                    Container(
                      height: 50,
                    ),

                    Column(
                      children: [
                        SizedBox(
                          width: 350,
                          height: 40,
                          child: RaisedButton(
                            onPressed: FirebaseAuth.instance.currentUser!.uid==widget.uid?() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyActivityPage()));
                            }:(){},
                            color: Colors.yellow,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      width: 50,
                                    )),
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    "我舉辦的活動",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Expanded(flex: 3, child: Container(width: 100)),
                                const Expanded(
                                    flex: 1,
                                    child: Icon(Icons.arrow_forward_ios))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 15,
                        ),
                        SizedBox(
                          width: 350,
                          height: 40,
                          child: RaisedButton(
                            onPressed: FirebaseAuth.instance.currentUser!.uid==widget.uid?() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const UpComingActivity()));
                            }:(){},
                            color: Colors.red,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      width: 50,
                                    )),
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    "即將參加的活動",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Expanded(flex: 3, child: Container(width: 100)),
                                const Expanded(
                                    flex: 1,
                                    child: Icon(Icons.arrow_forward_ios))
                              ],
                            ),
                          ),
                        ),
                        Container(height: 15),
                        SizedBox(
                          width: 350,
                          height: 40,
                          child: RaisedButton(
                            onPressed: FirebaseAuth.instance.currentUser!.uid==widget.uid?() {
                               Navigator.push(context, MaterialPageRoute(builder: (context) => const ExpiredActivity()));
                            }:(){},
                            color: Colors.blue,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      width: 50,
                                    )),
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    "曾經參與的活動",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Expanded(flex: 3, child: Container(width: 100)),
                                const Expanded(
                                    flex: 1,
                                    child: Icon(Icons.arrow_forward_ios))
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // FirebaseAuth.instance.currentUser!.uid == widget.uid
                        //     ? FollowButton(
                        //         backgroundColor: mobileBackgroundColor,
                        //         borderColor: Colors.grey,
                        //         text: 'Sign Out',
                        //         textColor: primaryColor,
                        //         function: () async {
                        //           await AuthMethods().signOut();
                        //           Navigator.of(context).pushReplacement(
                        //               MaterialPageRoute(
                        //                   builder: (context) =>
                        //                       const LoginPage()));
                        //         })
                        //     : Container(),
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          );
  }

  Column buildStateColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(num.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey)),
        ),
      ],
    );
  }

  Widget buildAbout(user) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [
            Text(
              "About",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
          ]),
          const SizedBox(
            height: 24,
          ),
          Text(
            user,
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ));
}
