import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:gthqrscanner/services/google_sheets/attendance_sheets.dart';
import 'package:gthqrscanner/views/students/students.dart';

class LectureDeleteDialog extends StatelessWidget {
  const LectureDeleteDialog({
    Key? key,
    required this.lectureController,
    required this.data,
    required this.index,
  }) : super(key: key);

  final LectureController lectureController;
  final List data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          ListTile(
            title: const Text('Attendance'),
            trailing: const Icon(Icons.person_add_alt_1_outlined),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                  lectureController.deleteLecture(id: data[index - 1].id);
                  Navigator.pop(context);
                },
                btnOkText: 'YES',
              ).show();
            },
          ),
        ],
      ),
    );
  }
}
