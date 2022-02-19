import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:gthqrscanner/project/google_sheets/attendance_sheets.dart';
import 'package:provider/provider.dart';

import 'attendance_model/students/view_all_students.dart';
import 'colors/mycolor.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
    required this.data,
  }) : super(key: key);
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    var lectureController =
        Provider.of<LectureController>(context, listen: false);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: MyColor.buttonColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text('Geeta Technical Hub'),
                ],
              )),
          ListTile(
            leading: const Icon(Icons.event_available_rounded),
            title: const Text('Soft Skill'),
            onTap: () {
              AttendanceSheetApi.init();
              lectureController.setLecture(
                  'SoftSkill', 'SoftSkills', 'Soft Skill');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllStudents(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.event_available_rounded),
            title: const Text('Social Media'),
            onTap: () {
              AttendanceSheetApi.init();
              lectureController.setLecture(
                  'SocialMedia', 'SocialMedias', 'Social Media');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllStudents(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
