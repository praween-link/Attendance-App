import 'package:flutter/material.dart';
import 'package:gthqrscanner/controller/branch_controller.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'colors/mycolor.dart';
import 'google_sheets/attendance_sheets.dart';

class AddNewLecture extends StatefulWidget {
  static const routeName = '/addNewLecture';
  const AddNewLecture({Key? key}) : super(key: key);

  @override
  _AddNewLectureState createState() => _AddNewLectureState();
}

class _AddNewLectureState extends State<AddNewLecture> {
  final _formKey = GlobalKey<FormState>();

  String key = '';
  String title = '';
  String sheetName = '';
  int row = 1;
  int column = 5;
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
        title: const Text('Add New Lecture'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  BranchController.spreadSheetTitle,
                  style: const TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Divider(),
                TextFormField(
                  onChanged: (value) => setState(() => key = value),
                  decoration: const InputDecoration(
                    hintText: 'Without any space and special charactor*',
                    label: Text('Enter Unique Key*'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Key cannot be empty!';
                    }
                  },
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  onChanged: (value) => setState(() => title = value),
                  decoration: const InputDecoration(
                    hintText: 'Enter title*',
                    label: Text('Enter title*'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Title cannot be empty!';
                    }
                  },
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  onChanged: (value) => setState(() => sheetName = value),
                  decoration: const InputDecoration(
                    hintText: 'Enter google sheet name*',
                    label: Text('Sheet name*'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Sheet name cannot be empty!';
                    }
                  },
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  initialValue: '1',
                  onChanged: (value) => setState(() => row = int.parse(value)),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter last row in number*',
                    label: Text('Last row in number*'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Row numner cannot be empty!';
                    }
                  },
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  initialValue: '5',
                  onChanged: (value) =>
                      setState(() => column = int.parse(value)),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter last column in number*',
                    label: Text('Last column in number*'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Column number cannot be empty!';
                    }
                  },
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.SCALE,
                        dialogType: DialogType.WARNING,
                        body: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Add $title lecture!',
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Are you sure to new lecture!',
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
                          lectureController.addNewLecture(
                              key: key,
                              title: title,
                              sheetName: sheetName,
                              row: row,
                              column: column,
                              startDate:
                                  '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}');
                          AttendanceSheetApi.insertDate(
                              context,
                              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                              row,
                              column);
                          Navigator.pop(context);
                        },
                        btnOkText: 'YES',
                      ).show();
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Add New Lecture',
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
      ),
    );
  }
}
