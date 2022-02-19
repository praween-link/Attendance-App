import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class LectureController extends ChangeNotifier {
  // static String selectedLecture = 'SoftSkill';
  static var student = FirebaseFirestore.instance.collection('Students');
  //---------------------------
  // static var selectedLecture = FirebaseFirestore.instance
  //     .collection('Attendance')
  //     .doc('SoftSkill')
  //     .collection('SoftSkills');
  // static String lectureTitle = 'Soft Skills';

  // static var selectedLecture = FirebaseFirestore.instance
  //     .collection('Attendance')
  //     .doc('SocialMedia')
  //     .collection('SoftSkills');
  // static String lectureTitle = 'Soft Skills';
  // static String sheetName = 'Soft Skill'; //'Lecture1';// 'Soft Skill'

  // static var selectedLecture = FirebaseFirestore.instance
  //     .collection('Attendance')
  //     .doc(lectureId)
  //     .collection(lectureCollection);
  static String lectureId = 'SocialMedia';
  static String lectureCollection = 'SocialMedias';
  static String sheetName = 'Social Media'; //'Lecture1';// 'Soft Skill'

  //

  void setLecture(String lId, String lCol, String sheetname) {
    lectureId = lId;
    lectureCollection = lCol;
    sheetName = sheetname;
    notifyListeners();
  }
  //---------------------------
}
