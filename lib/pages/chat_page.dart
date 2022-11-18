import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sports_club/models/recorder.dart';
import 'package:sports_club/utils/colors.dart';
import '../models/recorder.dart';
import 'package:sports_club/pages/add_record_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);
  @override
  State<ChatPage> createState() => _recordsportStatePage();
}

class _recordsportStatePage extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appbarColor,
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text("消耗熱量紀錄"),
          )),
      body: StreamBuilder<List<Recorder>>(
        stream: readRecorder(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something was wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final recorders = snapshot.data!;
            return ListView(
              children: recorders.map(buildRecorder).toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: appbarColor,
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddRecord())),
      ),
    );
  }
}

Widget buildBarItem(IconData icon, String sportName) {
  return Container(
      width: 50.0,
      height: 50.0,
      margin: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green[200],
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(
          icon: Icon(
            icon,
            size: 35,
          ),
          onPressed: () {},
        ),
      ]));
}

Widget buildRecorder(Recorder recorder) => ListTile(
      leading: buildBarItem(Icons.sports_basketball_outlined, recorder.sport),
      title: Text('${recorder.sport}      ${recorder.time}min'),
      subtitle: Text('cost ${recorder.costhot} cal'),
      tileColor: Colors.white,
      trailing: Icon(Icons.keyboard_arrow_right),
      onLongPress: () {
        // final docUser=FirebaseFirestore.instance
        //     .collection('collection').doc('');
        // docUser.delete();
      },
    );
Stream<List<Recorder>> readRecorder() => FirebaseFirestore.instance
    .collection('collection')
    .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Recorder.fromJson(doc.data())).toList());
