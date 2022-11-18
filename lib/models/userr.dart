import 'package:cloud_firestore/cloud_firestore.dart';

import '../helpers/appcolors.dart';
import 'category.dart';
import '../pages/home_page.dart';

class Userr {
  final String activityname;
  final String date;
  final String location;
  final String picture;
  final String sporttype;
  final String time;
  final String whopost;
  final String whopostname;
  final String uid;
  final String limitnum;
  final String introduce;
  final List<dynamic> joinlist;

  Userr({
    required this.activityname,
    required this.date,
    required this.location,
    required this.picture,
    required this.sporttype,
    required this.time,
    required this.whopost,
    required this.whopostname,
    required this.uid,
    required this.limitnum,
    required this.introduce,
    required this.joinlist,
  });

  Map<String, dynamic> toJson() => {
        'activityname': activityname,
        'date': date,
        'location': location,
        'picture': picture,
        'sporttype': sporttype,
        'whopostname': whopostname,
        'time': time,
        'whopost': whopost,
        'uid' : uid,
        'limitnum' :limitnum,
        'introduce' :introduce,
        'joinlist' :joinlist,
      };

  static Userr fromJson(Map<String, dynamic> json) => Userr(
        activityname: json['activityname'],
        date: json['date'],
        location: json['location'],
        picture: json['picture'],
        sporttype: json['sporttype'],
        time: json['time'],
        whopost: json['whopost'],
        whopostname: json['whopostname'],
        uid: json['uid'],
        limitnum: json['limitnum'],
        introduce: json['introduce'],
        joinlist: json['joinlist'],
      );

  static Category getDataFromServer(Userr user) {
    return Category(
      color: AppColors.MEATS,
      name: user.activityname,
      time: user.date,
      imgName: user.picture,
      whopostname: user.whopostname,
      //icon: IconFontHelper.MEATS,
      subCategories: [],
      location: user.location,
      whopost: user.whopost,
      sport: user.sporttype,
      uid: user.uid,
      limitnum: user.limitnum,
      introduce:user.introduce,
      joinlist:user.joinlist,
    );
  }
}
