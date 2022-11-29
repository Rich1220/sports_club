import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sports_club/pages/selectedcategorypage.dart';
import 'package:sports_club/utils/colors.dart';

import '../Widgets/categorycard.dart';
import '../helpers/utils.dart';
import '../models/category.dart';
import '../models/post.dart';
import '../models/userr.dart';
import '../services/remote_service.dart';

class MyActivityPage extends StatefulWidget {
  const MyActivityPage({Key? key}) : super(key: key);

  @override
  State<MyActivityPage> createState() => _MyActivityPageState();
}

class _MyActivityPageState extends State<MyActivityPage> {
  late List<Category> categories = Utils.getMockedCategories();
  //新打的
  List<Post>? posts;
  // String? selectedValue = posts?[0].title;
  // print(posts);
  var isLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //loadYourData();
    // fetch data from API
    getData;
    // loadFirbase();
  }

  get getData async {
    posts = await RemoteService().getPosts();
    if (posts != null) {
      print("No data");
      if (mounted) {
        setState(() {
          isLoaded = true;
        });
      }
    } else {
      print(posts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        title: const Text(
          "我舉辦的活動",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder<List<Userr>>(
            // initialData: getData().asStream,
            stream: FirebaseFirestore.instance //列出所有
                .collection('Users')
                .where('whopost',isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots()
                .map((snapshots) => snapshots.docs
                    .map((doc) => Userr.fromJson(doc.data()))
                    .toList()),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong!  ${snapshot.error}');
              } else if (snapshot.hasData) {
                final users = snapshot.data!;

                categories = users.map(Userr.getDataFromServer).toList();

                return ListView.builder(
                    padding: EdgeInsets.only(bottom: 120),
                    itemCount: categories.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      return CategoryCard(
                          category: categories[index],
                          onCardClick: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectedCategoryPage(
                                          categories[index].imgName,
                                          categories[index].name,
                                          categories[index].time,
                                          categories[index].location,
                                          categories[index].sport,
                                          categories[index].whopost,
                                          categories[index].uid,
                                          categories[index].introduce,
                                          categories[index].limitnum,
                                          categories[index].joinlist,
                                        )));
                          });
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
