import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gthqrscanner/project/attendance_model/students/view_all_students.dart';
import 'package:gthqrscanner/project/colors/mycolor.dart';
import 'package:gthqrscanner/project/google_sheets/attendance_sheets.dart';

class LectureController extends ChangeNotifier {
  final _firebase = FirebaseFirestore.instance;
  
  static String lectureId = '';
  static String lectureCollection = '';
  static String sheetName = ''; 

  //

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
    _firebase.collection('Attendance').doc(key).set({
      'sheetname': sheetName,
      'title': title,
    }).then((value) {
      _firebase
          .collection('Attendance')
          .doc(key)
          .collection('${key}s')
          .doc('lastRowNo')
          .set({
        'column': column,
        'row': row - 1,
        'sheet': sheetName,
        'status': false,
        'date': startDate,
      }).then((value) => print(''));
    });
  }

  getAllLecutresFromDB() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebase.collection('Attendance').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data!.docs;
          return ListView.builder(
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
                          const SizedBox(height: 20),
                          Text(
                            'Geeta Technical Hub',//Attendance App
                            style: TextStyle(
                              color: MyColor.textcolor5,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2, 
                            ),
                          ),
                          Text(
                            'Attendance App',
                            style: TextStyle(
                              color: MyColor.textcolor5,
                              fontSize: 21.0,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 38.0, right: 38.0, bottom: 8.0, top: 8.0),
                        child: GestureDetector(
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
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: MyColor.buttonColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(50.0),
                                bottomLeft: Radius.circular(5.0),
                                bottomRight: Radius.circular(50.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(4, 8),
                                  color: MyColor.buttonSplaceColor5,
                                  blurRadius: 10.0,
                                  spreadRadius: 2,
                                ),
                                BoxShadow(
                                  offset: const Offset(2, 4),
                                  color: MyColor.buttonSplaceColor2,
                                  blurRadius: 9.0,
                                  spreadRadius: 2,
                                ),
                              ]
                            ),
                          ),
                        ),
                      );
              });
        } else if (snapshot.hasError) {
          return const Text('Something is wrong!');
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
