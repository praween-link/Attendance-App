import 'package:flutter/material.dart';
import 'package:gthqrscanner/constants/colors/mycolor.dart';
import 'package:gthqrscanner/controller/branch_controller.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:gthqrscanner/controller/student_controller.dart';
import 'package:gthqrscanner/model/student.dart';
import 'package:gthqrscanner/services/google_sheets/attendance_sheets.dart';
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
  String caterory = '';
  final _formKey = GlobalKey<FormState>();
  String spresdSheetId = '';
  String sheetName = '';

  String t = '';
  bool insert = true;

  final _formKey2 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var myController = Provider.of<MyController>(context);
    if (insert) {
      spresdSheetId = BranchController.spreadSheetId;
      insert = false;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.appBarColor,
        title: const Text('Add New Students'),
        leading: Builder(
          builder: (BuildContext context) => GestureDetector(
            child: const Icon(
              Icons.chevron_left_sharp,
              size: 32,
            ),
            onTap: () => Navigator.pop(context),
          ),
        ),
        // actions: [
          // Center(
          //     child: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text(
          //     (myController.lastRow - 1).toString(),
          //     style:
          //         const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          //   ),
          // )),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //----------------------------------
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
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter branch and year',
                          labelText: 'Student branch and year',
                        ),
                        onChanged: (value) {
                          setState(() {
                            caterory = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Branch and year field cannot be empty!';
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
                              Student.caterory: caterory,
                            };
                            var added = await AttendanceSheetApi.insertRow(
                                [student], context);
                            added ? myController.addNewStudent(
                                roll: roll,
                                name: name,
                                phone: phone,
                                caterory: caterory,
                                date:
                                    '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}',
                                // row: myController.lastRow + 1,
                                p: false) : null;
                            added ? myController.lastRowNo(
                                // row: myController.lastRow + 1,
                                col: myController.lastColumn) : null;
                            added ? Navigator.pop(context): null;
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
                          backgroundColor: MaterialStateProperty.all<Color>(
                              MyColor.appBarColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'OR',
                  style: TextStyle(fontSize: 18),
                ),
                Divider(
                    thickness: 5, color: MyColor.appBarColor.withOpacity(0.2)),
                Form(
                  key: _formKey2,
                  child: Column(
                    children: [
                      //----------------------------------
                      TextFormField(
                        initialValue: BranchController.spreadSheetId,
                        decoration: const InputDecoration(
                          hintText: 'Enter Sheet Id',
                          labelText: 'Sheet Id',
                        ),
                        onChanged: (value) {
                          setState(() {
                            spresdSheetId = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Sheet id cannot be empty!';
                          }
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter Sheet Name',
                          labelText: 'Sheet Name',
                        ),
                        onChanged: (value) {
                          setState(() {
                            sheetName = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Sheet name cannot be empty!';
                          }
                        },
                      ),
                      const SizedBox(height: 25),
                      const Text('1. roll, 2. name, 3. phone, 4. caterory'),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: () async {
                          if (!myController.studentAdding && _formKey2.currentState!.validate()) {
                            myController.updateAddingProccess(true);
                            await AttendanceSheetApi.getStudentData(
                              context: context,
                              ssid: spresdSheetId,
                              sheetname: sheetName,
                            );
                            //---
                            for (var d in myController.test) {
                              final student = {
                                Student.roll: d['roll'],
                                Student.name: d['name'],
                                Student.phone: d['phone'],
                                Student.caterory: d['caterory'],
                              };
                              await AttendanceSheetApi.insertRow(
                                  [student], context);
                              await myController.addNewStudent(
                                roll: d['roll'],
                                name: d['name'],
                                phone: d['phone'],
                                caterory: d['caterory'],
                                date:
                                    '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}',
                                // row: myController.lastRow + 1,
                                p: false,
                              );//
                              await myController.lastRowNo(
                                  // row: myController.lastRow + 1,
                                  col: myController.lastColumn);
                            }
                            myController.updateAddingProccess(true);
                            Navigator.pop(context);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Add Students From Excel',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              myController.studentAdding ? MyColor.appBarColor.withOpacity(0.4) : MyColor.appBarColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                      ),
                      myController.studentAdding
                          ? const CircularProgressIndicator()
                          : const Text(''),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
