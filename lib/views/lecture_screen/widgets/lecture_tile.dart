import 'package:flutter/material.dart';
import 'package:gthqrscanner/constants/colors/mycolor.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:gthqrscanner/services/google_sheets/attendance_sheets.dart';
import 'package:gthqrscanner/views/students/students.dart';
import 'package:provider/provider.dart';

import 'lecture_delete_dialog.dart';

class LectureTile extends StatelessWidget {
  const LectureTile({Key? key, required this.data, required this.index})
      : super(key: key);
  final List<dynamic> data;
  final int index;

  @override
  Widget build(BuildContext context) {
    var lectureController = Provider.of<LectureController>(context);
    var boxDecoration = BoxDecoration(
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
      ],
    );
    return Padding(
      padding:
          const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 8.0, top: 8.0),
      child: GestureDetector(
        onLongPress: () => showDialog<String>(
          context: context,
          builder: (context) => LectureDeleteDialog(lectureController: lectureController, data: data, index: index),
        ),
        onTap: () {
          lectureController.setLecture(data[index - 1].id,
              '${data[index - 1].id}s', data[index - 1]['sheetname']);
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
          decoration: boxDecoration,
        ),
      ),
    );
  }
}
