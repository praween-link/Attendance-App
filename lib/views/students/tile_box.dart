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
      t = myController.tt[i]['roll'];
      ti = i + 2;
      rowsId.addAll({myController.tt[i]['roll']: i + 2});
    }
  }

  String col = '';

  @override
  Widget build(BuildContext context) {
    var myController = Provider.of<MyController>(context);
    myController.addRowsId();
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                      Text(
                        'Branch & Year: ${widget.data[widget.index]['caterory']}',
                        style: const TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        'Roll No: ${widget.data[widget.index]['roll']}',
                        style: const TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'Name: ${widget.data[widget.index]['name']}',
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        widget.data[widget.index]['attendance']
                                    [myController.selectedLecture] ??
                                false
                            ? 'Persent'
                            : 'Absent',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: widget.data[widget.index]['attendance']
                                      [myController.selectedLecture] ??
                                  false
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
                    ],
                  ),
                  Text(
                    col,
                    style: const TextStyle(fontSize: 5),
                  ),
                ],
              ),
              FlutterSwitch(
                value: widget.data[widget.index]['attendance']
                        [myController.selectedLecture] ??
                    false,
                onToggle: (value) async {
                  // int findedColIndex = -1;
                  if (myController.selectedLecture != '') {
                    AttendanceSheetApi.getRows(context); //--
                    setState(() {
                      col = '';
                    });
                    //---------------Column Number----------------
                    // for (int i = myController.firstColumn + 1;
                    //     i <= myController.secondColumn;
                    //     i++) {
                    //   final colvalue = await AttendanceSheetApi
                    //       .attendanceSheet!.cells
                    //       .cell(column: i, row: 1);

                    //   if (colvalue.value ==
                    //       "${myController.selectedLecture}-${myController.currentDate}") {
                    //     // setState(() {
                    //     //   // col += myController.currentDate.toString();
                    //     //   // col += i.toString();
                    //     //   col += colvalue.value.toString();
                    //     //   col += '|';
                    //     // });
                    //     findedColIndex = i;
                    //   }
                    // }
                    //-------------------------------//
                    var roll = await widget.data[widget.index]['roll'];
                    int rid = myController.rowsId[roll] ?? -1;
                    final r = await AttendanceSheetApi.attendanceSheet!.cells
                        .cell(column: 1, row: rid);
                        //
                    if (r.value == widget.data[widget.index]['roll']) {
                      await AttendanceSheetApi.attendanceSheet!
                          .values //------------------- ATTENDANCE OF STUDENT ------------------------------------------------------------------
                          .insertValue(
                              widget.data[widget.index]['attendance']
                                      [myController.selectedLecture]??false
                                  ? 'Absent'
                                  : 'Present',
                              // column: myController.lastColumn,
                              // column: findedColIndex,
                              column: myController.firstColumn+myController.selectedLectureIndex+1,
                              row: rid);
                    }
                    await widget._firestore
                        .collection('AttendanceP')
                        .doc(BranchController.branchId)
                        .collection('${BranchController.branchId}s')
                        .doc(LectureController.lectureId)
                        .collection(LectureController.lectureCollection)
                        .doc(widget.data[widget.index]['roll'])
                        // .update({'status': ! widget.data[widget.index]['status']});
                        .update({
                      'attendance.${myController.selectedLecture}':
                          // false
                          widget.data[widget.index]['attendance']
                                      [myController.selectedLecture] ==
                                  null
                              ? true
                              : !widget.data[widget.index]['attendance']
                                  [myController.selectedLecture]
                    });
                  }
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
