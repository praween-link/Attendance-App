import 'package:flutter/material.dart';
import 'package:gthqrscanner/controller/student_controller.dart';
import 'package:provider/provider.dart';

import 'services/google_sheets/attendance_sheets.dart';

class TestScreen extends StatefulWidget {
  static const routeName = '/test';
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    var myController = Provider.of<MyController>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            AttendanceSheetApi.getRows(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Text(myController.tt.toString()),
      ),
    );
  }
}
