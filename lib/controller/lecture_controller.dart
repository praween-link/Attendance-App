import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gthqrscanner/views/lecture_screen/widgets/lecture_list_view.dart';

import 'branch_controller.dart';

class LectureController extends ChangeNotifier {
  String searchingKey = '';
  void updateKey(String key) {
    searchingKey = key;
    notifyListeners();
  }

  //
  final _firebase = FirebaseFirestore.instance;

  static String lectureId = '';
  static String lectureCollection = '';
  static String sheetName = '';

  // bool indecator = true;
  // void indecators(bool ind) {
  //   indecator = ind;
  //   notifyListeners();
  // }

  void setLecture(String lId, String lCol, String sheetname) {
    lectureId = lId;
    lectureCollection = lCol;
    sheetName = sheetname;
    notifyListeners();
  }

  //---------------------------

  void addNewLecture(
      {required String key,
      required String title,
      required String sheetName,
      required int row,
      required int column,
      required String startDate}) {
    _firebase
        .collection('AttendanceP')
        .doc(BranchController.branchId)
        .collection('${BranchController.branchId}s')
        .doc(key)
        .set({
      'sheetname': sheetName,
      'title': title,
    }).then((value) {
      _firebase
          .collection('AttendanceP')
          .doc(BranchController.branchId)
          .collection('${BranchController.branchId}s')
          .doc(key)
          .collection('${key}s')
          .doc('lastRowNo')
          .set({
        'column': column,
        'row': row,
        'sheet': sheetName,
        'status': false,
        'date': startDate,
        'lastcolumn': column,
      }).then((value) => print(''));
    });
  }

  Future deleteLecture({required String id}) async {
    _firebase
        .collection('AttendanceP')
        .doc(BranchController.branchId)
        .collection('${BranchController.branchId}s')
        .doc(id)
        .delete()
        .then(
          (value) {},
        );
    notifyListeners();
  }

  getAllLecutresFromDB() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebase
          .collection('AttendanceP')
          .doc(BranchController.branchId)
          .collection('${BranchController.branchId}s')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var listData = snapshot.data!.docs;
          var data = [];
          if (searchingKey == '') {
            data.addAll(listData);
          } else {
            for (var d in listData) {
              if (d['caterory'].contains(searchingKey)) {
                data.add(d);
              }
            }
          }
          // data.addAll(listData);
          return LectureListView(data: data);
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
