import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gthqrscanner/constants/colors/mycolor.dart';
import 'package:gthqrscanner/controller/student_controller.dart';
import 'package:gthqrscanner/views/add/student/add_student.dart';
import 'package:provider/provider.dart';

class AllStudents extends StatefulWidget {
  static const routeName = '/allStudents';
  const AllStudents({Key? key}) : super(key: key);

  @override
  State<AllStudents> createState() => _AllStudentsState();
}

class _AllStudentsState extends State<AllStudents> {
  String scanningError = '';
  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<MyController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.appBarColor,
        title: const Text('Students'),
        leading: Builder(
          builder: (BuildContext context) => GestureDetector(
              child: const Icon(
                Icons.chevron_left_sharp,
                size: 32,
              ),
              onTap: () {
                controller.updateKey('');
                Navigator.pop(context);
              }),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              // final r = await AttendanceSheetApi.attendanceSheet!.cells
              //         .cell(column: 1, row: 1);
              controller.addTodayDate(
                  context: context,
                  date:
                      '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  row: 1,
                  col: controller.lastColumn, firstC: controller.firstColumn, secondC: controller.secondColumn);
            },
            icon: const Icon(Icons.date_range_rounded),
          ),
          IconButton(
            onPressed: () {
              qrscan(context);
            },
            icon: const Icon(Icons.camera),
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, AddNewStudent.myroute),
            icon: const Icon(Icons.person_add_alt_1_outlined),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (context) => AlertDialog(
                title: Column(
                  children: [
                    ListTile(
                      title: const Text('Add New Student'),
                      trailing: const Icon(Icons.person_add_alt_1_outlined),
                      onTap: () =>
                          Navigator.pushNamed(context, AddNewStudent.myroute),
                    ),
                    ListTile(
                      title: const Text('Update Date'),
                      trailing: const Icon(Icons.date_range_rounded),
                      onTap: () async {
                        controller.addTodayDate(
                            context: context,
                            date:
                                '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                            row: 1,
                            col: controller.lastColumn, firstC: controller.firstColumn, secondC: controller.secondColumn);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                        title: const Text('Reset Attendance'),
                        trailing: const Icon(Icons.restart_alt),
                        onTap: () {
                          controller.resetAllStudentsAttendance(
                              studentsId: controller.studentsId);
                          Navigator.pop(context);
                        }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: controller.getAllStudents(),
    );
  }

  //
  Future qrscan(BuildContext constext) async {
    var controller = Provider.of<MyController>(context, listen: false);
    try {
      await BarcodeScanner.scan().then(
        (value) async {
          controller.changeQRResult(result: value.rawContent.toString());
        },
      );
    } on PlatformException catch (error) {
      if (error.code == BarcodeScanner.cameraAccessDenied) {
        setState(() =>
            scanningError = 'The user did not grant the camera permission!');
      } else {
        setState(() => scanningError = 'Unknown error: $error');
      }
    } on FormatException {
      setState(() => scanningError =
          'null (User returned using the "back"-button before scan');
    } catch (error) {
      setState(() => scanningError = 'Unknown error: $error');
    }
  }
}
