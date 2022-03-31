import 'package:flutter/material.dart';

import 'student_header.dart';
import 'student_tile.dart';

class StudentListView extends StatelessWidget {
  const StudentListView({Key? key, required this.data}) : super(key: key);
  final List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length + 1,
      itemBuilder: (BuildContext context, int index) {
        return index == 0 ? const StudentHeader() : StudentTile(data: data, index: index);
      },
    );
  }
}