import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gthqrscanner/constants/colors/mycolor.dart';
import 'package:gthqrscanner/views/lecture_screen/lectures.dart';

class BranchController extends ChangeNotifier {
  final _firebase = FirebaseFirestore.instance;
  static String spreadSheetId = '';
  static String spreadSheetTitle = '';
  //
  static String branchId = '';
  //---------

  void addNewSheet(
      {required String key,
      required String spreadSheetId,
      required String spreadSheetTitle}) {
    _firebase.collection('AttendanceP').doc(key).set({
      'spreadSheetId': spreadSheetId,
      'title': spreadSheetTitle,
    }).then((value) => print(''));
  }

  //
  //
  getAllBranchFromDB() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebase.collection('AttendanceP').snapshots(),
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
                            'Geeta Technical Hub', //Attendance App
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
                            left: 18.0, right: 18.0, bottom: 8.0, top: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            branchId = data[index - 1].id;
                            spreadSheetId = data[index - 1]['spreadSheetId'];
                            spreadSheetTitle = data[index - 1]['title'];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Lectures(),
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
