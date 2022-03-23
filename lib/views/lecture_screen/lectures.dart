import 'package:flutter/material.dart';
import 'package:gthqrscanner/constants/colors/mycolor.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:provider/provider.dart';

import '../add/lecture/add_lecture.dart';

class Lectures extends StatelessWidget {
  const Lectures(
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lectureController =
        Provider.of<LectureController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) => GestureDetector(
            child: const Icon(
              Icons.chevron_left_sharp, 
              size: 32,
            ),
            onTap: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: MyColor.appBarColor,
        title: const Text('GTH Attendance App'),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>const AddNewLecture(),
                ),
              );
          }, icon: const Icon(Icons.add))
        ],
      ),
      body:
          lectureController.getAllLecutresFromDB(),
    );
  }
}
