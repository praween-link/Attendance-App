import 'package:flutter/material.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:gthqrscanner/project/attendance_model/controller/my_controller.dart';
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
      appBar: AppBar(title: Text((controller.lastRow-2).toString()),),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(LectureController.sheetName),
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
              Text('$roll, $name, $phone'),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final student = {
                      Student.roll: roll,
                      Student.name: name,
                      Student.phone: phone,
                    };
                    await AttendanceSheetApi.insertRow([student], context);
                    controller.addNewStudent(roll, name, phone,
                        '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}',
                        controller.lastRow+1, false);
                    controller.lastRowNo(controller.lastRow+1, controller.lastColumn);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add New Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
