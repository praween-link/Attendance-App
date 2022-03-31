// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gthqrscanner/controller/branch_controller.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:gthqrscanner/services/google_sheets/attendance_sheets.dart';
import 'package:gthqrscanner/views/students/widgets/student_list_view.dart';

class MyController extends ChangeNotifier {
  //
  String selectedLecture = '';
  int selectedLectureIndex = -1;
  void seletedLectureUpdate(String s, int index) {
    selectedLecture = s;
    selectedLectureIndex = index;
    notifyListeners();
  }

  dynamic tt = '';
  void gettestAllData(dynamic td) {
    tt = td;
    notifyListeners();
  }

  //--------------------------------------
  bool studentAdding = false;
  void updateAddingProccess(bool isAdding) {
    studentAdding = isAdding;
    notifyListeners();
  }

  //--- Scannering result data ---
  String qrresult = 'No data';
  String scannedRollNo = '';
  bool availableInDB = false;
  Map<String, dynamic> sturentsRowData = {};
  //
  void changeQRResult({required String result}) async {
    qrresult = result;
    scannedRollNo = qrresult.split('\n')[0];
    availableInDB = studentsId.contains(scannedRollNo);
    //
    if (availableInDB) {
      int rid = rowsId[scannedRollNo] ?? -1;
      final r = await AttendanceSheetApi.attendanceSheet!.cells
          .cell(column: 1, row: rid);
      //
      if (r.value == scannedRollNo) {
        await AttendanceSheetApi.attendanceSheet!
            .values //------------------- ATTENDANCE OF STUDENT ------------------------------------------------------------------
            .insertValue('Present',
                column: firstColumn + selectedLectureIndex + 1, row: rid);
      }
      await firestore
          .collection('AttendanceP')
          .doc(BranchController.branchId)
          .collection('${BranchController.branchId}s')
          .doc(LectureController.lectureId)
          .collection(LectureController.lectureCollection)
          .doc(scannedRollNo)
          // .update({'status': ! widget.data[widget.index]['status']});
          .update({'attendance.$selectedLecture': true});
    }
    //
    notifyListeners();
  }
  //

  dynamic test = '';
  List<Map<String, dynamic>> allStudents = [];
  Future updateTest(dynamic t) async {
    test = t;
    // allStudents.add(t);
    notifyListeners();
  }

  //---------------------------FIREBASE-------------------
  final firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> allstudents = [];

  String fwithP = 'true';
  String fwithA = 'false';

  // int lastRow = -1;
  int firstColumn = -1;
  int secondColumn = -1;
  void currentColumnUpdate(int fc, int sc) {
    firstColumn = fc;
    secondColumn = sc;
  }

  int lastColumn = -1;
  String currentDate = '';

  void updateCurrentLastRow(
      // int r,
      int c,
      String d) {
    // lastRow = r;
    lastColumn = c;
    currentDate = d;
    // notifyListeners();
  }

  Future addNewStudent(
      {required String roll,
      required String name,
      required String phone,
      required String caterory,
      required String date,
      // required int row,
      required bool p}) async {
    firestore
        .collection('AttendanceP')
        .doc(BranchController.branchId)
        .collection('${BranchController.branchId}s')
        .doc(LectureController.lectureId)
        .collection(LectureController.lectureCollection)
        .doc(roll)
        .set(
      {
        'roll': roll,
        'name': name,
        'phone': phone,
        'caterory': caterory,
        // 'row': row,
        'status': p,
        'attendance': {}
      },
    ).then(
      (value) {},
    );
    notifyListeners();
  }

  Future deleteStudentData({required String roll}) async {
    firestore
        .collection('AttendanceP')
        .doc(BranchController.branchId)
        .collection('${BranchController.branchId}s')
        .doc(LectureController.lectureId)
        .collection(LectureController.lectureCollection)
        .doc(roll)
        .delete()
        .then(
          (value) {},
        );
    notifyListeners();
  }

  void addTodayDate(
      {required BuildContext context,
      required String date,
      required int row,
      required int col,
      required int firstC,
      required int secondC}) async {
    final r = await AttendanceSheetApi.attendanceSheet!.values
        .value(column: col, row: 1);
    // xx = '$col, $r, "d-$date"';
    if (r != "d-$date") {
      //
      await AttendanceSheetApi.insertDate(context, "d-$date", row,
          col + BranchController.allLecutres.length + 1);
      //

      firestore
          .collection('AttendanceP')
          .doc(BranchController.branchId)
          .collection('${BranchController.branchId}s')
          .doc(LectureController.lectureId)
          .collection(LectureController.lectureCollection)
          .doc('lastRowNo')
          .update(
        {
          'date': date,
          'column': col + BranchController.allLecutres.length + 1,
          'lastcolumn': col
        },
        //
      ).then(
        (value) {},
      );
      //
      //-------------------------------//
      for (int i = 0; i < BranchController.allLecutres.length; i++) {
        await AttendanceSheetApi.insertDate(context,
            "${BranchController.allLecutres[i]}-$date", row, secondC + i + 1);
      }
      //-------------------------------//
    }
    notifyListeners();
  }

  Future lastRowNo({required int col}) async {
    firestore
        .collection('AttendanceP')
        .doc(BranchController.branchId)
        .collection('${BranchController.branchId}s')
        .doc(LectureController.lectureId)
        .collection(LectureController.lectureCollection)
        .doc('lastRowNo')
        .update(
      {'column': col},
    ).then(
      (value) {},
    );
    notifyListeners();
  }

  List<String> studentsId = [];
  bool searching = false;
  String searchingKey = '';
  void updateKey(String key) {
    searchingKey = key;
    notifyListeners();
  }

  ///
  ///
  Map<String, int> rowsId = {};
  void addRowsId() {
    for (int i = 0; i < tt.length; i++) {
      rowsId.addAll({tt[i]['roll']: i + 2});
    }
    // notifyListeners();
  }

  //--0000
  String gg = '';
  void ggg(String g) {
    gg = g;
    notifyListeners();
  }

  //
  // Initial Selected Value
  String dropdownvalue = 'Item 1';

  void selectedDropDownLecture(String selected) {
    dropdownvalue = selected;
    notifyListeners();
  }

  // List of items in our dropdown menu
  List<String> items = [];

  ///
  getAllStudents() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('AttendanceP')
          .doc(BranchController.branchId)
          .collection('${BranchController.branchId}s')
          .doc(LectureController.lectureId)
          .collection(LectureController.lectureCollection)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var mydata = snapshot.data!.docs;
          List<Map<String, dynamic>> data = [];
          if (searchingKey == '') {
            for (var d in mydata) {
              if (d.id == 'lastRowNo') {
                updateCurrentLastRow(
                    // d['row'],
                    d['column'],
                    d['date']);

                currentColumnUpdate(d['lastcolumn'] ?? 0, d['column'] ?? 0);
              } else {
                studentsId.add(d.id);
                studentsId = studentsId.toSet().toList();
                sturentsRowData.addAll({
                  // '${d['roll']}': d['row'],
                  '${d['roll']}status': d['status']
                });
                //
                data.add({
                  'roll': d['roll'],
                  'name': d['name'],
                  'phone': d['phone'],
                  'caterory': d['caterory'],
                  // 'row': d['row'],
                  'status': d['status'],
                  'attendance': d['attendance'],
                });
                data = data.toSet().toList();
              }
            }
          } else {
            for (var d in mydata) {
              if (d.id == 'lastRowNo') {
                updateCurrentLastRow(
                    // d['row'],
                    d['column'],
                    d['date']);
                currentColumnUpdate(d['lastcolumn'], d['column']);
              } else {
                studentsId.add(d.id);
                studentsId = studentsId.toSet().toList();
                sturentsRowData.addAll({
                  // '${d['roll']}': d['row'],
                  '${d['roll']}status': d['status']
                });
                //
                if (d['roll'].contains(searchingKey) ||
                    d['name']
                        .toLowerCase()
                        .contains(searchingKey.toLowerCase()) ||
                    d['caterory']
                        .toLowerCase()
                        .contains(searchingKey.toLowerCase())) {
                  data.add({
                    'roll': d['roll'],
                    'name': d['name'],
                    'phone': d['phone'],
                    'caterory': d['caterory'],
                    // 'row': d['row'],
                    'status': d['status'],
                    'attendance': d['attendance'],
                  });
                  data = data.toSet().toList();
                }
              }
            }
          }

          return StudentListView(data: data);
        } else if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  List<Map<String, dynamic>> mydata = [];
  getAllStudentsFromDB() async {
    var snapshots = firestore
        .collection('AttendanceP')
        .doc(BranchController.branchId)
        .collection('${BranchController.branchId}s')
        .doc(LectureController.lectureId)
        .collection(LectureController.lectureCollection)
        .snapshots();
    await for (var snapshot in snapshots) {
      for (var data in snapshot.docs) {
        mydata.add({
          'roll': data.data()['roll'],
          'name': data.data()['name'],
          'phone': data.data()['phone'],
          'caterory': data.data()['caterory'],
          // 'row': data.data()['row'],
          'status': data.data()['status'],
          'attendance': data.data()['attendance'],
        });
      }
    }
  }

  void resetAllStudentsAttendance({required List<String> studentsId}) {
    List<String> ids = studentsId.toSet().toList();
    for (String studentid in ids) {
      firestore
          .collection('AttendanceP')
          .doc(BranchController.branchId)
          .collection('${BranchController.branchId}s')
          .doc(LectureController.lectureId)
          .collection(LectureController.lectureCollection)
          .doc(studentid)
          .update(
        {'attendance.$selectedLecture': false},
      ).then(
        (value) => print(''),
      );
    }
  }
}
