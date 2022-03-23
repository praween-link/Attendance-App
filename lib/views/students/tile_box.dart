import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gthqrscanner/constants/colors/mycolor.dart';
import 'package:gthqrscanner/controller/branch_controller.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:gthqrscanner/controller/student_controller.dart';
import 'package:gthqrscanner/services/google_sheets/attendance_sheets.dart';
import 'package:provider/provider.dart';

class TileCard extends StatefulWidget {
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
  State<TileCard> createState() => _TileCardState();
}

class _TileCardState extends State<TileCard> {
  String t = '';
  int ti = -1;
  Map<String, int> rowsId = {};
  void getRowId() {
    var myController = Provider.of<MyController>(context);
    ti = -5;
    for (int i = 0; i < myController.tt.length; i++) {
      // if (myController.tt[i]['roll'] == roll) {
      // setState(() {
        t = myController.tt[i]['roll'];
        ti = i + 2;
        rowsId.addAll({myController.tt[i]['roll']: i + 2});
      // });
      // }
    }
    // return ti;
  }

  @override
  Widget build(BuildContext context) {
    var myController = Provider.of<MyController>(context);
    // var tti = getRowId('4918144');
    // getRowId();
    myController.addRowsId();
    // return Center(child: Text(myController.rowsId.toString()));
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
                      Text(
                        LectureController.sheetName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      // Removed Here ID
                      Text(
                        'Branch & Year: ${widget.data[widget.index]['caterory']}',
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'Roll No: ${widget.data[widget.index]['roll']}',
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'Name: ${widget.data[widget.index]['name']}',
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
                        widget.data[widget.index]['status']
                            ? 'Persent'
                            : 'Absent',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: widget.data[widget.index]['status']
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      const Text(
                        '*',
                        style: TextStyle(
                            color: Color(0xffFF6600),
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800),
                      ),
                      // )
                      // ),
                    ],
                  )
                ],
              ),
              // myController.attendanceProcess ? const CircularProgressIndicator() :
              FlutterSwitch(
                value: widget.data[widget.index]['status'],
                onToggle: (value) async {
                  AttendanceSheetApi.getRows(context); //--
                  var roll = await widget.data[widget.index]['roll'];
                  int rid = myController.rowsId[roll] ?? -1;
                  final r = await AttendanceSheetApi.attendanceSheet!.cells
                      .cell(column: 1, row: rid);
                  // var roll = await widget.data[widget.index]['roll'];
                  // final r = await AttendanceSheetApi.attendanceSheet!.cells
                  //     .cell(column: 1, row: getRowId(roll));//--===========================

                  if (r.value == widget.data[widget.index]['roll']) {
                    // var rowindex = await widget.data[widget.index]['row'];
                    await AttendanceSheetApi.attendanceSheet!
                        .values //------------------- ATTENDANCE OF STUDENT ------------------------------------------------------------------
                        .insertValue(
                            !widget.data[widget.index]['status']
                                ? 'Present'
                                : 'Absent',
                            column: myController.lastColumn,
                            row: rid);
                  }
                  await widget._firestore
                      .collection('AttendanceP')
                      .doc(BranchController.branchId)
                      .collection('${BranchController.branchId}s')
                      .doc(LectureController.lectureId)
                      .collection(LectureController.lectureCollection)
                      .doc(widget.data[widget.index]['roll'])
                      .update({'status': !widget.data[widget.index]['status']});

                  // myController.updateAttendanceProcess(false);
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
