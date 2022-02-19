import 'package:flutter/material.dart';
import 'package:gthqrscanner/project/attendance_model/controller/my_controller.dart';
import 'package:gthqrscanner/project/model/lectures.dart';
import 'package:provider/provider.dart';

class SelectLecture extends StatelessWidget {
  const SelectLecture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<MyController>(context);
    return Column(
      children: [
        ListTile(
          title: const Text('Soft Skill'),
          leading: Radio(
            value: MyLectures.softSkill,
            groupValue: controller.selectedLecture,
            onChanged: (value) {},
          ),
          onTap: () {
            controller.changeSelectedLecture(MyLectures.softSkill);
          },
        ),
        ListTile(
          title: const Text('Web Development'),
          leading: Radio(
            value: MyLectures.webDevelopment,
            groupValue: controller.selectedLecture,
            onChanged: (value) {},
          ),
          onTap: () {
            controller.changeSelectedLecture(MyLectures.webDevelopment);
          },
        ),
        ListTile(
          title: const Text('Social Media'),
          leading: Radio(
            value: MyLectures.socialMedia,
            groupValue: controller.selectedLecture,
            onChanged: (value) {},
          ),
          onTap: () {
            controller.changeSelectedLecture(MyLectures.socialMedia);
          },
        ),
      ],
    );
  }
}
