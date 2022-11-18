import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sports_club/models/category.dart';

import 'appcolors.dart';

class Utils {
  static List<Category> getMockedCategories() {
    return [
      Category(
          color: AppColors.MEATS,
          name: "有人要一起打籃球嗎?",
          time: "2022/06/16(三) 16:00",
          imgName: "cat1",
          whopost: "",
          whopostname: "",
          location: "",
          sport: "",
          uid: "",
          limitnum: "",
          introduce: "",
          joinlist: [],
          //icon: IconFontHelper.MEATS,
          subCategories: []),
      Category(
          color: AppColors.VEGS,
          name: "一起去打籃球!",
          time: "2022/06/16(三) 16:00",
          imgName: "cat2",
          whopost: "",
          whopostname: "",
          location: "",
          sport: "",
          uid: "",
          limitnum: "",
          introduce: "",
          joinlist: [],
          //icon: IconFontHelper.VEGS,
          subCategories: []),
      Category(
          color: AppColors.SEEDS,
          name: "有人要一起打籃球嗎?",
          time: "2022/06/16(三) 16:00",
          imgName: "cat3",
          whopost: "",
          whopostname: "",
          location: "",
          sport: "",
          uid: "",
          limitnum: "",
          introduce: "",
          joinlist: [],
          //icon: IconFontHelper.SEEDS,
          subCategories: []),
      Category(
          color: AppColors.PASTRIES,
          name: "一起去打籃球!",
          time: "2022/06/16(三) 16:00",
          imgName: "cat4",
          whopost: "",
          whopostname: "",
          location: "",
          sport: "",
          uid: "",
          limitnum: "",
          introduce: "",
          joinlist: [],
          //icon: IconFontHelper.PASTRIES,
          subCategories: []),
      Category(
          color: AppColors.SPICES,
          name: "有人要一起打籃球嗎?",
          time: "2022/06/16(三) 16:00",
          imgName: "cat5",
          whopost: "",
          whopostname: "",
          location: "",
          sport: "",
          uid: "",
          limitnum: "",
          introduce: "",
          joinlist: [],
          //icon: IconFontHelper.SPICES,
          subCategories: []),
    ];
  }

  static void showSheet(BuildContext context,
          {required Widget child, required Null Function() onClicked}) =>
      showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
                actions: [
                  child,
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: Text('確定'),
                  onPressed: onClicked,
                ),
              ));

  static void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text, style: const TextStyle(fontSize: 24)),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
