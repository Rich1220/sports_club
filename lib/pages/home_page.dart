// 一開始顯示的活動列表
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sports_club/helpers/utils.dart';
import 'package:sports_club/models/category.dart';
import 'package:sports_club/pages/selectedcategorypage.dart';
import 'package:sports_club/services/remote_service.dart';
import 'package:sports_club/utils/colors.dart';
import '../helpers/appcolors.dart';
import '../models/userr.dart';
import '../widgets/categorycard.dart';

import 'package:sports_club/models/post.dart';
import 'dart:convert';

String tmp = "選擇校區分類";
String tmpsport = "  ALL";
String? a;
String test="棒球";

class CategoryListPage extends StatefulWidget {
  // 裡面包含dropdownbutton(為顯示使用者點選的選項)，因此需要用到statefulwidget
  CategoryListPage({required Key? key}) : super(key: key);
  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  // 要取得 device token，好讓 JS 檔案和 FCM TEST MESSAGE 可以傳送指定 token
  late List<Category> categories = Utils.getMockedCategories();
  //新打的
  List<Post>? posts;
  // String? selectedValue = posts?[0].title;
  // print(posts);
  var isLoaded = false;
  List<String> _items = [];

  Future<void> loadFromAssets() async {
    final String response = await rootBundle.loadString('assets/school.json');
    final data = await json.decode(response);
    for (int i = 0; i < data.length; ++i) {
      print(data[i]["schoolname"]);
      _items.add(data[i]["schoolname"]);
    }
    // _items = data;
    print(_items);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //loadYourData();
    // fetch data from API
    getData;
    loadFromAssets();
    // loadFirbase();
  }

  get getData async {
    posts = await RemoteService().getPosts();
    if (posts != null) {
      print("No data");
      if (mounted)
        setState(() {
          isLoaded = true;
        });
    } else {
      print(posts);
    }
  }

  String dropdownValue = "選擇校區分類";
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          backgroundColor: appbarColor,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                SizedBox(
                  height: 42,
                  child: ListView.builder(
                      itemCount: posts?.length,
                      itemBuilder: (context, index) {
                        return DropdownButton<String>(
                          value: tmp,
                          isExpanded: true,
                          icon: const Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Icon(Icons.arrow_drop_down),
                          ),
                          iconSize: 25,
                          underline: const SizedBox(),
                          hint: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(""),
                          ),
                          items: _items
                              .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Center(
                                child: Text(
                                  item,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              )))
                              .toList(),
                          onChanged: (value) => setState(() {
                            dropdownValue = value!;
                            print(tmp);
                            tmp = value;
                            a = "location";
                            print(value);
                          }),
                        );
                      }),
                ),
                Container(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        buildBarItem(Icons.android_outlined, "  ALL"),
                        buildBarItem(Icons.sports_basketball_outlined, "  籃球"),
                        buildBarItem(Icons.pool_outlined, "  游泳"),
                        buildBarItem(Icons.sports_baseball_outlined, "  棒球"),
                        buildBarItem(Icons.sports_tennis_outlined, "  網球"),
                        buildBarItem(Icons.sports_volleyball_outlined, "  排球"),
                        buildBarItem(Icons.sports_golf_outlined, "  高爾夫"),
                      ],
                    )),
                //tmp == "選擇校區分類" ? readUserss() : readUsers(),
                Expanded(
                  child: StreamBuilder<List<Userr>>(
                    // initialData: getData().asStream,
                      stream:checkstate(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                              'Something went wrong!  ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final users = snapshot.data!;

                          categories =
                              users.map(Userr.getDataFromServer).toList();

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
                                              builder: (context) =>
                                                  SelectedCategoryPage(
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
                )
              ]),
            ],
          ),
        ));

    // TODO: implement build
    throw UnimplementedError();
  }

  Widget buildUser(Userr user) => ListTile(
    leading: CircleAvatar(child: Text(user.activityname)),
    title: Text(user.location),
    subtitle: Text(user.sporttype),
  );

  checkstate() {
    if(tmp!="選擇校區分類"&&tmpsport!="  ALL"){
      return(readboth());
    }
    else if(tmp=="選擇校區分類"&&tmpsport!="  ALL"){//只選運動
      return(readonlysport());
    }
    else if(tmp!="選擇校區分類"&&tmpsport=="  ALL"){//只選運動
      return(readonlyschool());
    }
    else{
      return(readUsers());
    }
  }

  buildBarItem(IconData icon, String sportName) {
    return Container(
        width: 70.0,
        height: 70.0,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.yellow[300],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
            icon: Icon(
              icon,
              size: 35,
            ),
            onPressed: () {
              setState(() {
                tmpsport = sportName;
                a = "sporttype";
              });
            },
          ),
          Text(sportName),
        ]));
  }
}





Stream<List<Userr>> readUsers() => FirebaseFirestore.instance//列出所有
    .collection('Users')
    .snapshots()
    .map((snapshots) =>
    snapshots.docs.map((doc) => Userr.fromJson(doc.data())).toList());

Stream<List<Userr>> readonlyschool() => FirebaseFirestore.instance//只選學校
    .collection('Users')
    .where("location", isEqualTo: tmp) 
    .snapshots()
    .map((snapshots) =>
    snapshots.docs.map((doc) => Userr.fromJson(doc.data())).toList());
Stream<List<Userr>> readonlysport() => FirebaseFirestore.instance//只選運動
    .collection('Users')
    .where("sporttype", isEqualTo: tmpsport)
    .snapshots()
    .map((snapshots) =>
    snapshots.docs.map((doc) => Userr.fromJson(doc.data())).toList());
Stream<List<Userr>> readboth() => FirebaseFirestore.instance//兩者都選
    .collection('Users')
    .where("location", isEqualTo: tmp)
    .where("sporttype",isEqualTo: tmpsport)
    .snapshots()
    .map((snapshots) =>
    snapshots.docs.map((doc) => Userr.fromJson(doc.data())).toList());