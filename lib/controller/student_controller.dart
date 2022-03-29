// ignore_for_file: avoid_print

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gthqrscanner/constants/colors/mycolor.dart';
import 'package:gthqrscanner/controller/branch_controller.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:gthqrscanner/services/google_sheets/attendance_sheets.dart';
import 'package:gthqrscanner/views/students/tile_box.dart';

import 'my_bottom_sheet.dart';

class MyController extends ChangeNotifier {
  //
  String selectedLecture = '';
  void seletedLectureUpdate(String s) {
    selectedLecture = s;
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

  // bool attendanceProcess = false;
  // void updateAttendanceProcess(bool attendance) {
  //   attendanceProcess = attendance;
  //   notifyListeners();
  // }

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
      // int rr = sturentsRowData[scannedRollNo] ?? -1;
      int rid = rowsId[scannedRollNo] ?? -1;
      // final r = await AttendanceSheetApi.attendanceSheet!.cells
      //     .cell(column: 1, row: rr);
      final r = await AttendanceSheetApi.attendanceSheet!.cells
          .cell(column: 1, row: rid);

      if (r.value == scannedRollNo) {
        await AttendanceSheetApi.attendanceSheet!.values
            .insertValue('Present', column: lastColumn, row: rid);
      }
      await _firestore
          .collection('AttendanceP')
          .doc(BranchController.branchId)
          .collection('${BranchController.branchId}s')
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
  Future updateTest(dynamic t) async {
    test = t;
    // allStudents.add(t);
    notifyListeners();
  }

  //---------------------------FIREBASE-------------------
  final _firestore = FirebaseFirestore.instance;
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
    _firestore
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
    _firestore
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
      required int col, required int firstC, required int secondC}) async {
    final r = await AttendanceSheetApi.attendanceSheet!.values
        .value(column: col, row: 1);
    // xx = '$col, $r, "d-$date"';
    if (r != "d-$date") {
      //
      await AttendanceSheetApi.insertDate(context, "d-$date", row,
          col + BranchController.allLecutres.length + 1);
      //

      _firestore
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
        await AttendanceSheetApi.insertDate(
            context,
            "${BranchController.allLecutres[i]}-$date",
            row,
            secondC + i + 1);
      }
      //-------------------------------//
    }
    notifyListeners();
  }

  Future lastRowNo({required int col}) async {
    _firestore
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
      stream: _firestore
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

                currentColumnUpdate(d['lastcolumn'], d['column']);
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

          return ListView.builder(
            itemCount: data.length + 1,
            itemBuilder: (BuildContext context, int index) {
              // for (String s in BranchController.allLecutres) {
              //   items.add(s);
              // }
              return index == 0
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Today: ${currentDate.toString()}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await AttendanceSheetApi.getRows(
                                          context); //--
                                      //
                                      addTodayDate(
                                          context: context,
                                          date:
                                              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                                          row: 1,
                                          col: lastColumn, firstC: firstColumn, secondC: secondColumn);
                                    },
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            top: 2.0,
                                            bottom: 2.0),
                                        child: Text(
                                          rowsId.isNotEmpty
                                              ? 'Active'
                                              : 'Not active',
                                          style: TextStyle(
                                            color: rowsId.isNotEmpty
                                                ? Colors.green
                                                : Colors.red,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SelectableText(
                                "Lecture: ${LectureController.sheetName} (google sheet's name)",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                              //=======================
                              GestureDetector(
                                child: Text(
                                  '${selectedLecture == '' ? "Select Lecture" : "Selected Lecture - "} $selectedLecture',
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onTap: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const MyBottomSheet();
                                    },
                                  );
                                },
                              ),
                              ////==============================
                              Text(BranchController.allLecutres.toString()),
                              TextFormField(
                                initialValue: searchingKey,
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
                              color:
                                  MyColor.buttonSplaceColor5.withOpacity(0.6),
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
                              offset: const Offset(0, 8),
                              blurRadius: 0,
                              spreadRadius: 5,
                            ),
                          ],
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onLongPress: () {
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.SCALE,
                          dialogType: DialogType.WARNING,
                          body: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Delete roll-${data[index - 1]['roll']}!',
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Are you sure to delete student!',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          btnCancelOnPress: () {},
                          btnCancelText: 'NO',
                          btnOkOnPress: () {
                            //validate
                            deleteStudentData(roll: data[index - 1]['roll']);
                            // Navigator.pop(context);
                          },
                          btnOkText: 'YES',
                        ).show();
                      },
                      child: TileCard(
                          data: data, firestore: _firestore, index: index - 1),
                    );
            },
          );
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
    var snapshots = _firestore
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
      _firestore
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
