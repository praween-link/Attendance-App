import 'package:flutter/material.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:gthqrscanner/project/attendance_model/controller/my_controller.dart';
import 'package:gthqrscanner/project/colors/mycolor.dart';
import 'package:gthqrscanner/project/google_sheets/attendance_sheets.dart';
import 'package:gthqrscanner/project/google_sheets/student.dart';
import 'package:provider/provider.dart';

class AddNewStudent extends StatefulWidget {
  static const myroute = '/addNewStudent';
  const AddNewStudent({Key? key}) : super(key: key);

  @override
  _AddNewStudentState createState() => _AddNewStudentState();
}

class _AddNewStudentState extends State<AddNewStudent> {
  String roll = '';
  String name = '';
  String phone = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<MyController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.buttonColor,
        title: const Text('Add New Student'),
        leading: Builder(
          builder: (BuildContext context) => GestureDetector(
            child: const Icon(
              Icons.chevron_left_sharp,
              size: 32,
            ),
            onTap: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (controller.lastRow - 2).toString(),
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                LectureController.sheetName,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ), //
              const Divider(),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter student roll number',
                  labelText: 'Roll Number',
                ),
                onChanged: (value) {
                  setState(() {
                    roll = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Student field roll cannot be empty!';
                  }
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter student name',
                  labelText: 'Student name',
                ),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Name field cannot be empty!';
                  }
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter student contact number',
                  labelText: 'Student contact number',
                ),
                onChanged: (value) {
                  setState(() {
                    phone = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Contact field cannot be empty!';
                  }
                },
              ),
              // Text('$roll, $name, $phone'),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final student = {
                      Student.roll: roll,
                      Student.name: name,
                      Student.phone: phone,
                    };
                    await AttendanceSheetApi.insertRow([student], context);
                    controller.addNewStudent(
                        roll: roll,
                        name: name,
                        phone: phone,
                        date:
                            '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}',
                        row: controller.lastRow + 1,
                        p: false);
                    controller.lastRowNo(
                        row: controller.lastRow + 1,
                        col: controller.lastColumn);
                    Navigator.pop(context);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Add New Student',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(MyColor.buttonColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
