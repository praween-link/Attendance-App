import 'package:flutter/material.dart';
import 'package:gthqrscanner/project/attendance_model/add/add_student.dart';
import 'package:gthqrscanner/project/attendance_model/controller/my_controller.dart';
import 'package:gthqrscanner/project/colors/mycolor.dart';
import 'package:provider/provider.dart';

class AllStudents extends StatelessWidget {
  static const routeName = '/allStudents';
  const AllStudents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<MyController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.buttonColor,
        title: const Text('Students'),
        // title: Text(
        //     'Today: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
        actions: [
          IconButton(
            onPressed: () async {
              controller.addTodayDate(
                  context,
                  '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  1,
                  controller.lastColumn);
            },
            icon: const Icon(Icons.date_range_rounded),
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
                            context,
                            '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                            1,
                            controller.lastColumn);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                        title: const Text('Reset Attendance'),
                        trailing: const Icon(Icons.restart_alt),
                        onTap: () {
                          controller.resetAllStudentsAttendance(
                              controller.studentsId);
                          Navigator.pop(context);
                        }),
                    ListTile(
                      title: const Text('Add New Student'),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text('Add New Student'),
                      onTap: () {},
                    ),
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
}
