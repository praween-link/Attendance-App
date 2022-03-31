import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gthqrscanner/views/branch_home_screen/widgets/branch_list_view.dart';

class BranchController extends ChangeNotifier {
  final _firebase = FirebaseFirestore.instance;
  static String spreadSheetId = '';
  static String spreadSheetTitle = '';
  static List<String> allLecutres = [];

  void mySpreadSheetId(String spid) {
    spreadSheetId = spid;
    notifyListeners();
  }

  void mySpreadSheetTitle(String sptitle) {
    spreadSheetTitle = sptitle;
    notifyListeners();
  }

  void myAllLecutres(List<String> lectures) {
    allLecutres = lectures;
  }

  static String branchId = '';
  void myBranchId(String id) {
    branchId = id;
    notifyListeners();
  }
  //---------

  void addNewSheet(
      {required String key,
      required String spreadSheetId,
      required String spreadSheetTitle}) {
    _firebase.collection('AttendanceP').doc(key).set({
      'spreadSheetId': spreadSheetId,
      'title': spreadSheetTitle,
      'lectures': [],
    }).then((value) => print(''));
  }

  void addLecture(String key, String lecture) {
    _firebase.collection('AttendanceP').doc(key).update({
      'lectures': FieldValue.arrayUnion([lecture]),
    }).then((value) => print(''));
  }

  void deleteLecture(String key, List lectures) {
    _firebase.collection('AttendanceP').doc(key).update({
      'lectures': lectures,
    }).then((value) => print(''));
  }

  getAllBranchFromDB() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebase.collection('AttendanceP').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data!.docs;
          return BranchListViewBuilder(data: data);
        } else if (snapshot.hasError) {
          return const Center(child: Text('Something is wrong!'));
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
