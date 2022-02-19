import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:gthqrscanner/project/attendance_model/students/tile_box.dart';
import 'package:gthqrscanner/project/colors/mycolor.dart';
import 'package:gthqrscanner/project/google_sheets/attendance_sheets.dart';
import 'package:gthqrscanner/project/model/lectures.dart';

class MyController extends ChangeNotifier {
  MyLectures selectedLecture = MyLectures.softSkill;
  void changeSelectedLecture(MyLectures selected) {
    selectedLecture = selected;
    notifyListeners();
  }

  //---
  String qrresult = 'No data';
  void changeQRResult(String result) {
    qrresult = result;
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

  void addNewStudent(
      String roll, String name, String phone, String date, int row, bool p) {
    _firestore.collection('Attendance')
      .doc(LectureController.lectureId)
      .collection(LectureController.lectureCollection).doc(roll).set(
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

  void addTodayDate(BuildContext context, String date, int row, int col) async {
    final r = await AttendanceSheetApi.attendanceSheet!.cells
        .cell(column: col, row: 1);
    if (r.value != date) {
      //
      AttendanceSheetApi.insertDate(context, date, row, col + 1);
      //
      _firestore.collection('Attendance')
      .doc(LectureController.lectureId)
      .collection(LectureController.lectureCollection).doc('lastRowNo').update(
        {'date': date, 'column': col + 1},
      ).then(
        (value) {},
      );
    }
    notifyListeners();
  }

  void lastRowNo(int row, int col) {
    _firestore.collection('Attendance')
      .doc(LectureController.lectureId)
      .collection(LectureController.lectureCollection).doc('lastRowNo').update(
      {'row': row, 'column': col},
    ).then(
      (value) {},
    );
    notifyListeners();
  }

  // void makeAttendance(String roll, bool p, int row, int nextClm) async {
  //   final r = await AttendanceSheetApi.attendanceSheet!.cells
  //       .cell(column: 1, row: row);
  //   if (r.value == roll) {
  //     await AttendanceSheetApi.attendanceSheet!.values
  //         .insertValue('Present', column: nextClm, row: row);
  //   }
  //   _firestore.collection('Students').doc(roll).update({'status': p});
  //   notifyListeners();
  // }

  List<String> studentsId = [];
  bool searching = false;
  String searchingKey = '';
  void updateKey(String key) {
    searchingKey = key;
    notifyListeners();
  }

  getAllStudents() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Attendance')
      .doc(LectureController.lectureId)
      .collection(LectureController.lectureCollection).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var mydata = snapshot.data!.docs;

          List<Map<String, dynamic>> data = [];

          if (searchingKey == '') {
            for (var d in mydata) {
              if (d.id == 'lastRowNo') {
                studentsId.add(d.id);
                updateCurrentLastRow(d['row'], d['column'], d['date']);
              } else {
                data.add({
                  'roll': d['roll'],
                  'name': d['name'],
                  'phone': d['phone'],
                  'row': d['row'],
                  'status': d['status'],
                });
              }
            }
          } else {
            for (var d in mydata) {
              if (d.id == 'lastRowNo') {
                studentsId.add(d.id);
                updateCurrentLastRow(d['row'], d['column'], d['date']);
              } else {
                if (d['roll'].contains(searchingKey) ||
                    d['name'].contains(searchingKey)) {
                  data.add({
                    'roll': d['roll'],
                    'name': d['name'],
                    'phone': d['phone'],
                    'row': d['row'],
                    'status': d['status'],
                  });
                }
              }
            }
          }

          return ListView.builder(
            itemCount: data.length + 1,
            itemBuilder: (BuildContext context, int index) {
              //
              // index == 0
              //     ? print('')
              //     : data[index - 1].id == 'lastRowNo'
              //         ? updateCurrentLastRow(data[index - 1]['row'],
              //             data[index - 1]['column'], data[index - 1]['date'])
              //         : print('');
              //
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
                              Text('Today: ${currentDate.toString()}'),
                              Text(
                                  "Lecture: ${LectureController.sheetName} (google sheet's name)"),
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
                              color: MyColor.buttonSplaceColor.withOpacity(0.6),
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

  void resetAllStudentsAttendance(List<String> studentsId) {
    List<String> ids = studentsId.toSet().toList();
    for (String id in ids) {
      _firestore.collection('Attendance')
      .doc(LectureController.lectureId)
      .collection(LectureController.lectureCollection).doc(id).update(
        {'status': false},
      ).then(
        (value) => print(''),
      );
    }
  }
}
