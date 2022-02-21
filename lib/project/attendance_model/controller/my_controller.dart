import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gthqrscanner/controller/branch_controller.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:gthqrscanner/project/attendance_model/students/tile_box.dart';
import 'package:gthqrscanner/project/colors/mycolor.dart';
import 'package:gthqrscanner/project/google_sheets/attendance_sheets.dart';

class MyController extends ChangeNotifier {
  //--------------------------------------

  //--- Scannering result data ---
  String qrresult = 'No data';
  String scannedRollNo = '';
  bool availableInDB = false;
  Map<String, dynamic> sturentsRowData = {};
  void changeQRResult({required String result}) async {
    qrresult = result;
    scannedRollNo = qrresult.split('\n')[0];
    availableInDB = studentsId.contains(scannedRollNo);
    //
    if (availableInDB) {
      int rr = sturentsRowData[scannedRollNo] ?? -1;
      final r = await AttendanceSheetApi.attendanceSheet!.cells
          .cell(column: 1, row: rr);

      if (r.value == scannedRollNo) {
        await AttendanceSheetApi.attendanceSheet!.values.insertValue('Present',
            column: lastColumn,
            row: rr);
      }
      _firestore
          .collection('AttendanceP').doc(BranchController.branchId).collection('${BranchController.branchId}s')
          .doc(LectureController.lectureId)
          .collection(LectureController.lectureCollection)
          .doc(scannedRollNo)
          .update({'status': true});
    }
    //
    notifyListeners();
  }
  //

  dynamic test = '';
  List<Map<String, dynamic>> allStudents = [];
  void updateTest(dynamic t) {
    test = t;
    // allStudents.add(t);
    notifyListeners();
  }

  //---------------------------FIREBASE-------------------
  final _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> allstudents = [];

  String fwithP = 'true';
  String fwithA = 'false';

  int lastRow = -1;
  int lastColumn = -1;
  String currentDate = '';

  void updateCurrentLastRow(int r, int c, String d) {
    lastRow = r;
    lastColumn = c;
    currentDate = d;
    // notifyListeners();
  }

  void addNewStudent({
      required String roll, required String name, required String phone, required String date, required int row,required bool p}) {
    _firestore
        .collection('AttendanceP').doc(BranchController.branchId).collection('${BranchController.branchId}s')
        .doc(LectureController.lectureId)
        .collection(LectureController.lectureCollection)
        .doc(roll)
        .set(
      {
        'roll': roll,
        'name': name,
        'phone': phone,
        'row': row,
        'status': p,
        'attendance': {}
      },
    ).then(
      (value) {},
    );
    notifyListeners();
  }

  void addTodayDate({required BuildContext context, required String date, required int row, required int col}) async {
    final r = await AttendanceSheetApi.attendanceSheet!.cells
        .cell(column: col, row: 1);
    if (r.value != date) {
      //
      AttendanceSheetApi.insertDate(context, date, row, col + 1);
      //
      _firestore
          .collection('AttendanceP').doc(BranchController.branchId).collection('${BranchController.branchId}s')
          .doc(LectureController.lectureId)
          .collection(LectureController.lectureCollection)
          .doc('lastRowNo')
          .update(
        {'date': date, 'column': col + 1},
      ).then(
        (value) {},
      );
    }
    notifyListeners();
  }

  void lastRowNo({required int row, required int col}) {
    _firestore
        .collection('AttendanceP').doc(BranchController.branchId).collection('${BranchController.branchId}s')
        .doc(LectureController.lectureId)
        .collection(LectureController.lectureCollection)
        .doc('lastRowNo')
        .update(
      {'row': row, 'column': col},
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
  ///
  getAllStudents() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('AttendanceP').doc(BranchController.branchId).collection('${BranchController.branchId}s')
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
                updateCurrentLastRow(d['row'], d['column'], d['date']);
              } else {
                studentsId.add(d.id);
                studentsId = studentsId.toSet().toList();
                sturentsRowData.addAll({'${d['roll']}': d['row'], '${d['roll']}status': d['status']});
                //
                data.add({
                  'roll': d['roll'],
                  'name': d['name'],
                  'phone': d['phone'],
                  'row': d['row'],
                  'status': d['status'],
                });
                data = data.toSet().toList();
              }
            }
          } else {
            for (var d in mydata) {
              if (d.id == 'lastRowNo') {
                updateCurrentLastRow(d['row'], d['column'], d['date']);
              } else {
                studentsId.add(d.id);
                studentsId = studentsId.toSet().toList();
                sturentsRowData.addAll({'${d['roll']}': d['row'], '${d['roll']}status': d['status']});
                //
                if (d['roll'].contains(searchingKey) ||
                    d['name'].contains(searchingKey)) {
                  data.add({
                    'roll': d['roll'],
                    'name': d['name'],
                    'phone': d['phone'],
                    'row': d['row'],
                    'status': d['status'],
                  });
                  data = data.toSet().toList();
                }
              }
            }
          }

          return ListView.builder(
            itemCount: data.length + 1,
            itemBuilder: (BuildContext context, int index) {
              return index == 0
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 10, top: 12, bottom: 8, right: 19),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Today: ${currentDate.toString()}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17, color: Colors.white),),
                              Text(
                                  "Lecture: ${LectureController.sheetName} (google sheet's name)", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17, color: Colors.white),),
                              TextField(
                                onChanged: (value) => updateKey(value),
                                decoration: const InputDecoration(
                                  hintText: 'Search student',
                                  prefixIcon: Icon(Icons.search,
                                      color: Colors.blueGrey),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueGrey),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueGrey),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: MyColor.buttonSplaceColor5.withOpacity(0.6),
                              offset: const Offset(0, 0),
                              blurRadius: 5,
                              spreadRadius: 5,
                            ),
                            BoxShadow(
                              color: MyColor.buttonColor.withOpacity(0.6),
                              offset: const Offset(3, 3),
                              blurRadius: 2,
                              spreadRadius: 5,
                            ),
                            BoxShadow(
                              color: MyColor.buttonColor.withOpacity(0.2),
                              offset: const Offset(8, 8),
                              blurRadius: 0,
                              spreadRadius: 5,
                            ),
                          ],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                    )
                  : TileCard(
                      data: data, firestore: _firestore, index: index - 1);
            },
          );
        } else if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  List<Map<String, dynamic>> mydata = [];
  getAllStudentsFromDB() async {
    var snapshots = _firestore
        .collection('AttendanceP').doc(BranchController.branchId).collection('${BranchController.branchId}s')
        .doc(LectureController.lectureId)
        .collection(LectureController.lectureCollection)
        .snapshots();
    await for (var snapshot in snapshots) {
      for (var data in snapshot.docs) {
        mydata.add({
          'roll': data.data()['roll'],
          'name': data.data()['name'],
          'phone': data.data()['phone'],
          'row': data.data()['row'],
          'status': data.data()['status'],
        });
      }
    }
  }

  void resetAllStudentsAttendance({required List<String> studentsId}) {
    List<String> ids = studentsId.toSet().toList();
    for (String studentid in ids) {
      _firestore
          .collection('AttendanceP').doc(BranchController.branchId).collection('${BranchController.branchId}s')
          .doc(LectureController.lectureId)
          .collection(LectureController.lectureCollection)
          .doc(studentid)
          .update(
        {'status': false},
      ).then(
        (value) => print(''),
      );
    }
  }
}
