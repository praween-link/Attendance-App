import 'package:flutter/material.dart';

import 'lecture_header.dart';
import 'lecture_tile.dart';

class LectureListView extends StatelessWidget {
  const LectureListView({Key? key, required this.data}) : super(key: key);
  final List<dynamic> data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: data.length + 1,
        itemBuilder: (context, int index) {
          return index == 0 ? const LectureHeader() : LectureTile(data: data, index: index);
        });
  }
}

