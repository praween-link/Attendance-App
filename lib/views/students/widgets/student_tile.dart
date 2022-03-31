import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gthqrscanner/controller/student_controller.dart';
import 'package:provider/provider.dart';

import 'tile_box.dart';

class StudentTile extends StatelessWidget {
  const StudentTile({Key? key, required this.data, required this.index}) : super(key: key);
  final List<Map<String, dynamic>> data;
  final int index;

  @override
  Widget build(BuildContext context) {
    var studentController = Provider.of<MyController>(context);
    return GestureDetector(
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
            studentController.deleteStudentData(roll: data[index - 1]['roll']);
            // Navigator.pop(context);
          },
          btnOkText: 'YES',
        ).show();
      },
      child: TileCard(
          data: data,
          firestore: studentController.firestore,
          index: index - 1),
    );
  }
}
