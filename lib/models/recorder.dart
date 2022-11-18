import 'dart:ui';
import '../helpers/appcolors.dart';
import 'category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
class Recorder{
  String id;
  final String sport;
  final int time;
  final int costhot;
  Recorder({
    this.id='',
    required this.sport,
    required this.time,
    required this.costhot,
  });
  Map<String,dynamic>toJson()=>{
    'id':id,
    'sport':sport,
    'time':time,
    'costhot':costhot,
  };
  static Recorder fromJson(Map<String,dynamic>json)=>Recorder(
    id: json['id'],
    sport: json['sport'],
    time: json['time'],
    costhot: json['costhot'],

  );
}