import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gthqrscanner/project/attendance_model/controller/my_controller.dart';
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
            ? controller.updateCurrentLastRow(
                data[index]['row'], data[index]['column'], data[index]['date'])
            : print('');
        return data[index].id == 'lastRowNo' ? const Text('') : Text('');
        // : Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Container(
        //       decoration: BoxDecoration(
        //         color: Colors.grey.withOpacity(0.2),
        //         boxShadow: [
        //           BoxShadow(
        //             color: MyColor.tilesadow1.withOpacity(0.2),
        //             offset: const Offset(0, 0),
        //             blurRadius: 0,
        //             spreadRadius: 1,
        //           ),
        //           BoxShadow(
        //             color: MyColor.tilesadow1.withOpacity(0.3),
        //             offset: const Offset(4, 5),
        //             blurRadius: 8,
        //             spreadRadius: 1,
        //           ),
        //         ],
        //         borderRadius: const BorderRadius.all(
        //           Radius.circular(5.0),
        //         ),
        //       ),
        //       // width: w,
        //       height: 80,
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text(
        //                       data[index]['roll'],
        //                       style: const TextStyle(
        //                           fontSize: 16.0,
        //                           fontWeight: FontWeight.w800),
        //                     ),
        //                     Text(
        //                       data[index]['name'],
        //                     ),
        //                   ],
        //                 ),
        //                 Row(
        //                   children: [
        //                     Text(
        //                       data[index]['status'] ? 'Persent' : 'Absent',
        //                       style: TextStyle(
        //                         fontSize: 14.0,
        //                         fontWeight: FontWeight.w400,
        //                         color: data[index]['status']
        //                             ? Colors.green
        //                             : Colors.red,
        //                       ),
        //                     ),
        //                     const SizedBox(width: 5.0),
        //                     Container(
        //                         decoration: const BoxDecoration(
        //                           color: Colors.white,
        //                           borderRadius: BorderRadius.all(
        //                             Radius.circular(5.0),
        //                           ),
        //                         ),
        //                         child: Padding(
        //                           padding: const EdgeInsets.only(
        //                               left: 3.0, right: 3.0),
        //                           child: Text(
        //                             '5',
        //                             style: TextStyle(
        //                                 color: MyColor.buttonColor,
        //                                 fontSize: 14.0,
        //                                 fontWeight: FontWeight.w800),
        //                           ),
        //                         )),
        //                   ],
        //                 )
        //               ],
        //             ),
        //             FlutterSwitch(
        //               value: data[index]['status'],
        //               onToggle: (value) {
        //                 Provider.of<MyController>(context, listen: false)
        //                     .makeAttendance(
        //                         data[index]['roll'],
        //                         !data[index]['status'],
        //                         data[index]['row'],
        //                         5);
        //               },
        //               activeColor: Colors.green,
        //               inactiveColor: Colors.red,
        //               activeText: 'P',
        //               inactiveText: 'A',
        //               activeTextColor: Colors.blue,
        //               width: 50,
        //               height: 25,
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        // );
      },
    );
  }
}
