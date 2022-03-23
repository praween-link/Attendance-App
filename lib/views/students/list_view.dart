import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gthqrscanner/controller/student_controller.dart';
import 'package:provider/provider.dart';

class StudentListView extends StatelessWidget {
  const StudentListView({Key? key, required this.data}) : super(key: key);
  final List<QueryDocumentSnapshot<Object?>> data;
  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<MyController>(context);
    double w = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        data[index].id == 'lastRowNo'
            ? controller.updateCurrentLastRow(data[index]['column'], data[index]['date'])
            : print('');
        return data[index].id == 'lastRowNo' ? const Text('') : const Text('');
      },
    );
  }
}
