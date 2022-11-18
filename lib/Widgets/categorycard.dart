import 'dart:ffi';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sports_club/models/category.dart';

import '../models/category.dart';
// import 'dart:html';

class CategoryCard extends StatefulWidget {
  late Category category;
  Function onCardClick;
  CategoryCard({required this.category, required this.onCardClick});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    int limitnum = int.parse(widget.category.limitnum);
    int peopleNow = widget.category.joinlist.length;
    bool isMax = limitnum == peopleNow;
    return GestureDetector(
      
      onTap: () {
        widget.onCardClick();
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 0),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: const Color.fromARGB(164, 255, 255, 255),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  width: 140,
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.category.imgName))),
                ),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.local_activity_outlined,
                          color: Colors.indigoAccent,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                            height: 30,
                            child: Text(widget.category.name,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20))),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        const SizedBox(
                          child: Icon(
                            Icons.sports_baseball_outlined,
                            color: Colors.orange,
                          ),
                        ),
                        Text(widget.category.sport,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20)),
                        const SizedBox(
                          width: 8,
                        ),
                        const Icon(
                          Icons.access_time_outlined,
                          color: Colors.blue,
                        ),
                        Text(widget.category.time,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                            height: 25,
                            child: Text(widget.category.location,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20))),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        const Icon(Icons.person_add_alt_rounded),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          widget.category.joinlist.length.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          "/",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          widget.category.limitnum,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 80,),
                        isMax? Text("人數已滿",style: TextStyle(color: Colors.red),):Text("招募中~",style: TextStyle(color: Colors.green),),
                      ],
                      
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
