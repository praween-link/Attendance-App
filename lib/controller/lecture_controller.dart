import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gthqrscanner/constants/colors/mycolor.dart';
import 'package:gthqrscanner/services/google_sheets/attendance_sheets.dart';
import 'package:gthqrscanner/views/students/view_all_students.dart';
import 'package:provider/provider.dart';

import 'branch_controller.dart';
import 'student_controller.dart';

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
          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: data.length + 1,
              itemBuilder: (context, int index) {
                return index == 0
                    ? Column(
                        children: [
                          const SizedBox(height: 35),
                          Container(
                            margin: const EdgeInsets.only(left: 50, right: 50),
                            child: ClipRRect(
                              child: Image.asset('assets/img/ghublogo.png'),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Geeta Technical Hub', //Attendance App
                            style: TextStyle(
                              color: MyColor.textcolor5,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            'ATTENDANCE',
                            style: TextStyle(
                              color: MyColor.textcolor5,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                BranchController.spreadSheetTitle,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: MyColor.buttonColor.withOpacity(0.2),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 18.0, right: 18.0, bottom: 8.0, top: 8.0),
                        child: GestureDetector(
                          onLongPress: () => showDialog<String>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Column(
                                children: [
                                  ListTile(
                                    title: const Text('Attendance'),
                                    trailing: const Icon(
                                        Icons.person_add_alt_1_outlined),
                                    onTap: () {
                                      setLecture(
                                          data[index - 1].id,
                                          '${data[index - 1].id}s',
                                          data[index - 1]['sheetname']);
                                      AttendanceSheetApi.init();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AllStudents(),
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('Delete Lecture'),
                                    trailing: const Icon(Icons.delete),
                                    onTap: () async {
                                      AwesomeDialog(
                                        context: context,
                                        animType: AnimType.SCALE,
                                        dialogType: DialogType.WARNING,
                                        body: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'Delete!',
                                                style: TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "Are you sure to delete lecutre ${data[index - 1]['title']}'!",
                                                style: const TextStyle(
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
                                          deleteLecture(id: data[index - 1].id);
                                          Navigator.pop(context);
                                        },
                                        btnOkText: 'YES',
                                      ).show();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            setLecture(
                                data[index - 1].id,
                                '${data[index - 1].id}s',
                                data[index - 1]['sheetname']);
                            AttendanceSheetApi.init();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AllStudents(),
                              ),
                            );
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                data[index - 1]['title'],
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: MyColor.buttonColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(4, 8),
                                    color: MyColor.buttonSplaceColor5,
                                    blurRadius: 8.0,
                                    spreadRadius: 2,
                                  ),
                                ]),
                          ),
                        ),
                      );
              });
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
