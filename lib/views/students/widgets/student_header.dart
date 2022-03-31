import 'package:flutter/material.dart';
import 'package:gthqrscanner/constants/colors/mycolor.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:gthqrscanner/views/students/widgets/my_bottom_sheet.dart';
import 'package:gthqrscanner/controller/student_controller.dart';
import 'package:gthqrscanner/services/google_sheets/attendance_sheets.dart';
import 'package:provider/provider.dart';

class StudentHeader extends StatelessWidget {
  const StudentHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var studentController = Provider.of<MyController>(context);
    var boxDecoration = BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: MyColor.buttonSplaceColor5.withOpacity(0.6),
              offset: const Offset(0, 0),
              blurRadius: 5,
              spreadRadius: 5,
            ),
            BoxShadow(
              color: MyColor.buttonColor.withOpacity(0.6),
              offset: const Offset(3, 3),
              blurRadius: 2,
              spreadRadius: 5,
            ),
            BoxShadow(
              color: MyColor.buttonColor.withOpacity(0.2),
              offset: const Offset(0, 8),
              blurRadius: 0,
              spreadRadius: 5,
            ),
          ],
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
        );
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today: ${studentController.currentDate.toString()}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await AttendanceSheetApi.getRows(context); //--
                      //
                      studentController.addTodayDate(
                          context: context,
                          date:
                              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          row: 1,
                          col: studentController.lastColumn,
                          firstC: studentController.firstColumn,
                          secondC: studentController.secondColumn);
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                        child: Text(
                          studentController.rowsId.isNotEmpty
                              ? 'Active'
                              : 'Not active',
                          style: TextStyle(
                            color: studentController.rowsId.isNotEmpty
                                ? Colors.green
                                : Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ],
              ),
              SelectableText(
                "Lecture: ${LectureController.sheetName} (google sheet's name)",
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              //=======================
              GestureDetector(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18.0, top: 2.0, bottom: 2.0),
                    child: Text(
                      '${studentController.selectedLecture == '' ? "Select Lecture" : "Selected Lecture - "} ${studentController.selectedLecture}',
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.8),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
                onTap: () {
                  // showModalBottomSheet<void>(
                  //   context: context,
                  //   builder: (BuildContext context) {
                  // return const MyBottomSheet();
                  //   },
                  // );
                  showModalBottomSheet<void>(
                    isScrollControlled: true,
                    // backgroundColor: Colors.grey.withOpacity(0.9),
                    context: context,
                    builder: (context) => const MyBottomSheet(),
                  );
                },
              ),
              ////==============================
              // Text(BranchController.allLecutres.toString()),
              TextFormField(
                initialValue: studentController.searchingKey,
                onChanged: (value) => studentController.updateKey(value),
                decoration: const InputDecoration(
                  hintText: 'Search student',
                  prefixIcon: Icon(Icons.search, color: Colors.blueGrey),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                ),
              ),
            ],
          ),
        ),
        decoration: boxDecoration,
      ),
    );
  }
}
