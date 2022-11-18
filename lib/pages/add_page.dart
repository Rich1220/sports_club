import 'package:flutter/material.dart';
import 'package:sports_club/utils/colors.dart';
import 'dart:convert';
import 'createactivitypage.dart';

class SelectedSchoolPage extends StatefulWidget {
  const SelectedSchoolPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _SelectedSchoolPage createState() => _SelectedSchoolPage();
}

class _SelectedSchoolPage extends State<SelectedSchoolPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appbarColor,
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text("選擇活動舉辦校區"),
          )),
      body: Center(
        child: FutureBuilder(
          builder: (context, snapshot) {
            var showData = json.decode(snapshot.data.toString());
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                if (index != 0) {
                  return ListTile(
                      visualDensity: const VisualDensity(vertical: 3),
                      title: Text(showData[index]['schoolname'],
                          style:
                              const TextStyle(fontSize: 20.0)), //加const會rethrow
                      subtitle: Text(showData[index]['schooladdress'],
                          style: const TextStyle(fontSize: 17.0)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateActivityPage(
                                  showData[index]['schoolname'])),
                        );
                      });
                } else {
                  return Container();
                }
              },
              itemCount: showData?.length ?? 0,
            );
          },
          future:
              DefaultAssetBundle.of(context).loadString("assets/school.json"),
        ),
      ),
    );
  }
}
