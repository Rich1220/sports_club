import 'dart:io';
import 'package:sports_club/utils/colors.dart';

import '../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sports_club/widgets/datebuttonwidget.dart';
import 'package:sports_club/widgets/image_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../helpers/utils.dart';
import 'package:intl/intl.dart';
import '../widgets/timebuttonwidget.dart';
import 'package:sports_club/widgets/image_widget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:sports_club/resources/auth_methods.dart';

import 'home_page.dart';

class CreateActivityPage extends StatefulWidget {
  final showData;
  CreateActivityPage(this.showData, {Key? key}) : super(key: key);
  @override
  State<CreateActivityPage> createState() => _CreateActivityPage();
}

class _CreateActivityPage extends State<CreateActivityPage> {
  //FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  //FirebaseStorage storageRef = FirebaseStorage.instance;
  UploadTask? uploadTask;
  String collectionName = "userImages";

  String? URL;

  final controllerActivityName = TextEditingController();
  final controllerintroduce = TextEditingController();

  File? image;

  Future pickImage(ImageSource source) async {
    // 應該就是在說抓取圖片之後要如何顯示在模擬器上
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      //final imageTemporary = File(image.path);
      final imagePermanent = await saveImagePermanently(image.path);
      setState(() => this.image = imagePermanent);
    } on PlatformException catch (e) {
      print('Fialed to pick image: $e');
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  String? valueChoose1;
  String? valueChoose2;
  List listItem1 = [
    "  籃球",
    "  游泳",
    "  棒球",
    "  網球",
    "  排球",
    "  高爾夫",
  ];
  List limitnum = [
    ' 1',
    ' 2',
    ' 3',
    ' 4',
    ' 5',
    ' 6',
  ];
  DateTime dateTime = DateTime.now();

  Widget buildButton({
    required String title,
    required IconData icon,
    required VoidCallback onClicked,
  }) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(56),
          primary: Colors.white,
          onPrimary: Colors.black,
          textStyle: TextStyle(fontSize: 20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 16),
            Text(title),
          ],
        ),
        onPressed: onClicked,
      );

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appbarColor,
          title: Align(alignment: Alignment.centerLeft, child: Text("輸入活動資訊")),
        ),
        body: SingleChildScrollView(
            child: Stack(
                //alignment: Alignment.topCenter,
                children: <Widget>[
              Column(children: [
                Stack(children: [
                  SizedBox(
                    height: 300,
                    child: image != null
                        ? ImageWidget(
                            image: image!,
                            onClicked: (source) => pickImage(source))
                        : buildCoverImage(),
                  ),
                  Positioned(
                    right: 150,
                    bottom: 0,
                    child: RawMaterialButton(
                        elevation: 10,
                        fillColor: Colors.grey,
                        child: Icon(Icons.add_a_photo),
                        padding: EdgeInsets.all(15.0),
                        shape: CircleBorder(),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: Text(
                                    'Choose option',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: [
                                        // Camera
                                        InkWell(
                                            onTap: () =>
                                                pickImage(ImageSource.camera),
                                            splashColor: Colors.black,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.camera,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                Text('Camera',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black)),
                                              ],
                                            )),
                                        // Gallery
                                        InkWell(
                                            onTap: () =>
                                                pickImage(ImageSource.gallery),
                                            splashColor: Colors.blue,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.image,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                Text('Gallery',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black)),
                                              ],
                                            )),
                                        // Remove
                                        InkWell(
                                            onTap: () {},
                                            splashColor: Colors.black,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.remove,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                Text('Remove',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black)),
                                              ],
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }),
                  ),
                ]),
                // 舉辦校區(鎖死)
                Column(children: <Widget>[
                  SizedBox(height: height * 0.02),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Colors.red,
                      ),
                      Text(
                        widget.showData,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //活動名稱
                    SizedBox(height: height * 0.02),
                    TextFormField(
                      controller: controllerActivityName,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          labelText: "請輸入活動名稱",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 20)),
                    ),
                    SizedBox(height: height * 0.02),
                    //輸入簡短介紹
                    TextFormField(
                      minLines: 4,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                      controller: controllerintroduce,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          labelText: "請輸入介紹",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 20)),
                    ),
                  ],
                ),
                //選運動和人數
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          DropdownButton(
                            // 選擇運動項目欄位(下拉式清單)
                            dropdownColor: mobileBackgroundColor,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 36,
                            isExpanded: true,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 22),
                            hint: const Text(
                              "  請選擇運動項目",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey),
                            ),
                            value: valueChoose1,
                            onChanged: (newValue) {
                              setState(() {
                                valueChoose1 = newValue as String;
                              });
                            },
                            items: listItem1.map((valueItem) {
                              return DropdownMenuItem(
                                value: valueItem,
                                child: Text(valueItem,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          DropdownButton(
                            dropdownColor: mobileBackgroundColor,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 36,
                            isExpanded: true,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 22),
                            hint: const Text(
                              "  人數限制",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey),
                            ),
                            value: valueChoose2,
                            onChanged: (newValue) {
                              setState(() {
                                valueChoose2 = newValue as String;
                              });
                            },
                            items: limitnum.map((numItem) {
                              return DropdownMenuItem(
                                value: numItem,
                                child: Text(numItem,
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // 選擇日期
                    Expanded(
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.02),
                          Text(
                            textAlign: TextAlign.center,
                            '${dateTime.year}/${dateTime.month}/${dateTime.day}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          DateButtonWidget(
                              onClicked: () => Utils.showSheet(context,
                                      child: buildDatePicker(), onClicked: () {
                                    final datevalue = DateFormat('yyyy/MM/dd')
                                        .format(dateTime);
                                    Utils.showSnackBar(
                                        context, '選擇 "$datevalue"');
                                    Navigator.pop(context);
                                  }))
                        ],
                      ),
                    ),
                    // 選擇時間
                    Expanded(
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: height * 0.02),
                          Text(
                            textAlign: TextAlign.center,
                            '${dateTime.hour}:${dateTime.minute}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          TimeButtonWidget(
                              onClicked: () => Utils.showSheet(context,
                                      child: buildDateTimePicker(),
                                      onClicked: () {
                                    final timevalue =
                                        DateFormat('HH:mm').format(dateTime);
                                    Utils.showSnackBar(
                                        context, '選擇 "$timevalue"');
                                    Navigator.pop(context);
                                  }))
                        ],
                      ),
                    )
                  ],
                ),

                // 設置活動按鈕
                Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * 0.02),
                      Container(
                        height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 42),
                              primary: appbarColor),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const Icon(Icons.check_outlined, size: 28),
                              const SizedBox(width: 9),
                              const Text(
                                '創建活動 ',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          onPressed: () {
                            uploadImage();
                            showAlertDialog(context);
                          },
                        ),
                      ),
                    ])
              ]),
            ])));
  }

  //void setState(Null Function() param0) {}

  final double coverHeight = 280;

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: Image.network(
          'https://i.im.ge/2022/07/12/u4J6aF.webp',
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
      );

  Widget buildDatePicker() => SizedBox(
        height: 180,
        child: CupertinoDatePicker(
          minimumYear: DateTime.now().year,
          maximumYear: DateTime.now().year + 6,
          initialDateTime: DateTime.now(),
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (dateTime) =>
              setState(() => this.dateTime = dateTime),
        ),
      );

  Widget buildDateTimePicker() => SizedBox(
        height: 180,
        child: CupertinoDatePicker(
          initialDateTime: this.dateTime,
          mode: CupertinoDatePickerMode.time,
          //minimumDate: DateTime(
          //    DateTime.now().year, DateTime.now().month, DateTime.now().day),
          //maximumDate: DateTime(DateTime.now().year, 12, 31),
          //use24hFormat: true,
          onDateTimeChanged: (dateTime) =>
              setState(() => this.dateTime = dateTime),
        ),
      );

  // upload picture to firebase
  Future uploadImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(image!.path);
    final path = '{${directory.path}/$name}';
    final file = File(image!.path);

    final ref = FirebaseStorage.instance.ref(collectionName).child('$name');
    // uploadTask = ref.putFile(file);
    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshot = await uploadTask!.whenComplete(() {});
    URL = await snapshot.ref.getDownloadURL();

    final docUser = FirebaseFirestore.instance.collection("Users").doc();
    await FirebaseFirestore.instance.collection("Users").doc(docUser.id).set({
      'uid': docUser.id,
      'whopostname': await getMyData(),
      'activityname': controllerActivityName.text,
      'sporttype': valueChoose1!,
      'location': widget.showData,
      'date': '${dateTime.year}/${dateTime.month}/${dateTime.day}',
      'time': '${dateTime.hour}:${dateTime.minute}',
      'picture': URL,
      'whopost': FirebaseAuth.instance.currentUser!.uid,
      'introduce': controllerintroduce.text,
      'limitnum': valueChoose2!,
      'joinlist': [],
    });
    setState(() {
      uploadTask = null;
    });
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

  showAlertDialog(BuildContext context) {
    // Init
    AlertDialog dialog = AlertDialog(
      title: Text("您已經創建成功了!"),
      actions: [
        ElevatedButton(
            child: Text("OK"),
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
}
