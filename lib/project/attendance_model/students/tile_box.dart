import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gthqrscanner/controller/branch_controller.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:gthqrscanner/project/attendance_model/controller/my_controller.dart';
import 'package:gthqrscanner/project/colors/mycolor.dart';
import 'package:gthqrscanner/project/google_sheets/attendance_sheets.dart';
import 'package:provider/provider.dart';

class TileCard extends StatelessWidget {
  const TileCard({
    Key? key,
    required this.data,
    required FirebaseFirestore firestore,
    required this.index,
  })  : _firestore = firestore,
        super(key: key);

  final List<Map<String, dynamic>> data;
  final FirebaseFirestore _firestore;
  final int index;

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<MyController>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          boxShadow: [
            BoxShadow(
              color: MyColor.tilesadow1.withOpacity(0.2),
              offset: const Offset(0, 0),
              blurRadius: 0,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: MyColor.tilesadow1.withOpacity(0.3),
              offset: const Offset(4, 5),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        // width: w,
        // height: 80,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          // child:
          //     Text(data.toString()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(LectureController.sheetName, style: const TextStyle(fontWeight: FontWeight.w500),),
                      Text('ID: ${data[index]['row'].toString()}'),
                      Text(
                        'Roll No: ${data[index]['roll']}',
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'Name: ${data[index]['name']}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        data[index]['status']
                            ? 'Persent'
                            : 'Absent',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: data[index]['status']
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        '*',
                        style: TextStyle(
                            color: MyColor.buttonColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800),
                      ),
                      // )
                      // ),
                    ],
                  )
                ],
              ),
              FlutterSwitch(
                value: data[index]['status'],
                onToggle: (value) async {
                  final r = await AttendanceSheetApi.attendanceSheet!.cells
                      .cell(column: 1, row: data[index]['row']);
                      
                  if (r.value == data[index]['roll']) {
                    await AttendanceSheetApi.attendanceSheet!.values
                        .insertValue(
                            !data[index]['status']
                                ? 'Present'
                                : 'Adsent',
                            column: controller.lastColumn,
                            row: data[index]['row']);
                  }
                  _firestore
                      .collection('AttendanceP').doc(BranchController.branchId).collection('${BranchController.branchId}s')
                      .doc(LectureController.lectureId)
                      .collection(LectureController.lectureCollection)
                      .doc(data[index]['roll'])
                      .update({'status': !data[index]['status']});
                  // makeAttendance(data[index]['roll'],
                  //     !data[index]['status'], data[index]['row'], 5);
                },
                activeColor: Colors.green,
                inactiveColor: Colors.red,
                activeText: 'P',
                inactiveText: 'A',
                activeTextColor: Colors.blue,
                width: 50,
                height: 25,
              ),
              //
            ],
          ),
        ),
      ),
    );
  }
}
