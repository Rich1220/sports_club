// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sports_club/utils/colors.dart';
import 'package:flutter/services.dart';
import 'package:sports_club/pages/add_record_page.dart';

import '../models/recorder.dart';

class AddRecord extends StatefulWidget {
  const AddRecord({Key? key}) : super(key: key);

  @override
  State<AddRecord> createState() => _AddRecordState();
}


class _AddRecordState extends State<AddRecord> {
  List<String> g_items = ['未選擇', '男', '女'];
  String? g_selectedItem = '未選擇';
  List<String> sport_items = ['未選擇', '籃球', '游泳', '棒球', '網球','排球','高爾夫'];
  String? sport_selectedItem = '未選擇';
  double consumekcal = 0;
  TextEditingController _ageController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _highController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  int? name;
  int gender = 0;
  int sport = 0;
  String answerString = "輸入資料不符合要求無法計算";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        centerTitle: true,
        title: Text('熱量計算機'),
        actions: [
          IconButton(
            onPressed: () {
              final recorder = Recorder(
                sport: sport_selectedItem!,
                time: int.parse(_durationController.text),
                costhot:consumekcal.toInt(),
              );
              createrecord(recorder);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Row( //gender
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "性別",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                ),
                DropdownButton<String>(
                  value: g_selectedItem,
                  items: g_items
                      .map((item) =>
                      DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: TextStyle(fontSize: 24)),
                      ))
                      .toList(),
                  onChanged: (item) => setState(() => g_selectedItem = item),
                ),
              ],
            ),
            SizedBox(height: 15,),
            Row( //sport
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "運動",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                ),
                DropdownButton<String>(
                  value: sport_selectedItem,
                  items: sport_items
                      .map((item) =>
                      DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: TextStyle(fontSize: 24)),
                      ))
                      .toList(),
                  onChanged: (item) =>
                      setState(() => sport_selectedItem = item),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row( //high
              children: [
                Text(
                  "年齡",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                ),

                Container(
                  margin: EdgeInsets.only(left: 200),
                  height: 50,
                  width: 90,
                  child: TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,

                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    decoration: InputDecoration(
                      hintText: '年齡',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20,),
            Row( //high
              children: [
                Text(
                  "身高",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                ),

                Container(
                  margin: EdgeInsets.only(left: 200),
                  height: 50,
                  width: 90,
                  child: TextField(
                    controller: _highController,

                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    decoration: InputDecoration(
                      hintText: '身高(cm)',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20,),
            Row( //weight
              children: [
                Text(
                  "體重",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                ),

                Container(
                  margin: EdgeInsets.only(left: 200),
                  height: 50,
                  width: 90,
                  child: TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    decoration: InputDecoration(
                      hintText: '體重(kg)',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20,),
            Row( //tine
              children: [
                Text(
                  "持續時間",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                ),

                Container(
                  margin: EdgeInsets.only(left: 150),
                  height: 50,
                  width: 90,
                  child: TextField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ],
                    decoration: InputDecoration(
                      hintText: '時間(min)',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              ],
            ),

            SizedBox(height: 20,),

            RaisedButton(
              child: Text("開始計算"),
              onPressed: () {
                if (g_selectedItem == '女') {
                  gender = -161;
                }
                else if (g_selectedItem == '男') {
                  gender = 5;
                }
                else {
                  gender = 0;
                }
                if (sport_selectedItem == '游泳') {
                  sport = 10;
                }
                else if (sport_selectedItem == '棒球') {
                  sport = 8;
                }
                else if (sport_selectedItem == '網球') {
                  sport = 12;
                }
                else if (sport_selectedItem == '排球') {
                  sport = 11;
                }
                else if (sport_selectedItem == '高爾夫') {
                  sport = 6;
                }
                else if (sport_selectedItem == '籃球') {
                  sport = 12;
                }
                else {
                  sport = 0;
                }
                if (_weightController.text.isEmpty) {
                  _weightController.text = "0";
                }
                if (_highController.text.isEmpty) {
                  _highController.text = "0";
                }
                if (_ageController.text.isEmpty) {
                  _ageController.text = "0";
                }
                if (_durationController.text.isEmpty) {
                  _durationController.text = "0";
                }
                int w = int.parse(_weightController.text);
                int h = int.parse(_highController.text);
                int age = int.parse(_ageController.text);
                int dtime = int.parse(_durationController.text);
                setState(() {
                  consumekcal = cal_kcal(w, h, age, gender, dtime, sport);
                  if (consumekcal == 0) {
                    answerString = "輸入資料不符合要求無法計算";
                  }
                  else {
                    answerString = "消耗熱量為 ${consumekcal.round()} 大卡";
                  }
                });
                //check
                print("${g_selectedItem}${age}");
                print("${sport_selectedItem}${sport}");
                print("${consumekcal}");
              },
            ),
            Row(
              children: [
                Text(
                  (' ${answerString} '),
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future createrecord( Recorder recorder) async {
    final docUser = FirebaseFirestore.instance.collection('collection').doc();

    recorder.id=FirebaseAuth.instance.currentUser!.uid;
    final json = recorder.toJson();
    await docUser.set(json);
  }
}
double cal_kcal(int pkg,int pcm,int page,int gen,int time,int met){
  if(pkg==0||pcm==0||page==0||gen==0||time==0||met==0){
    return 0;
  }
  else{
    double bmr;
    double ans;
    bmr=10.0*pkg+6.25*pcm-5.0*page+ gen;
    ans=(bmr/24)*met*(time/60);
    return ans;
  }

}


