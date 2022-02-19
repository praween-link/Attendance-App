import 'package:flutter/material.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:gthqrscanner/project/attendance_model/controller/my_controller.dart';
import 'package:gthqrscanner/project/colors/mycolor.dart';
import 'package:gthqrscanner/project/drawer.dart';
import 'package:gthqrscanner/project/google_sheets/attendance_sheets.dart';
import 'package:gthqrscanner/project/home/select_lecture.dart';
import 'package:gthqrscanner/project/qr_scanner.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  static const myroute = 'homeScreen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<MyController>(context);
    var lectureController =
        Provider.of<LectureController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) => GestureDetector(
            child: Image.asset('assets/img/menu_icon.png'),
            onTap: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: MyColor.appBarColor,
        title: const Text('QR Scanner'),
        actions: [
          IconButton(
            onPressed: () async {
              await AttendanceSheetApi.init();
            },
            icon: const Icon(Icons.add_box_rounded),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Text('Current Time'),
                const SizedBox(height: 35),
                Container(
                  margin: const EdgeInsets.only(left: 50, right: 50),
                  child: ClipRRect(
                    child: Image.asset('assets/img/catoon.png'),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'QR SCANNER',
                  style: TextStyle(
                    color: MyColor.textcolor5,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return const SelectLecture();
                      },
                    );
                  },
                  child: const Text(
                    'Select for attendance',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
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
                const SizedBox(height: 5),
                Text(
                  controller.selectedLecture.toString(),
                  style: TextStyle(
                    color: MyColor.textcolor3,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const ScanQRCode(),
            Text(controller.qrresult),
            ElevatedButton(
              onPressed: () async {
                // final student = {
                //   Student.roll: '4918144',
                //   Student.name: 'Praween Kumar',
                //   Student.phone: 'praween@gmail.com',
                // };
                await AttendanceSheetApi.getRows(context);
              },
              child: const Text('add data in row'),
            ),
            Text(controller.test.toString()),
            Text(controller.allStudents.toString()),
            // ListTile(
            //   leading: const Icon(Icons.event_available_rounded),
            //   title: Text('Soft Skill-${LectureController.lectureTitle}'),
            //   onTap: () {
            //     lectureController.setLecture(
            //         FirebaseFirestore.instance
            //             .collection('Attendance')
            //             .doc('SoftSkill')
            //             .collection('SoftSkills'),
            //         'Soft Skills',
            //         'Soft Skill');
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const AllStudents(),
            //       ),
            //     );
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.event_available_rounded),
            //   title: Text('Social Media-${LectureController.sheetName}'),
            //   onTap: () {
            //     lectureController.setLecture(
            //         FirebaseFirestore.instance
            //             .collection('Attendance')
            //             .doc('SocialMedia')
            //             .collection('SocialMedias'),
            //         'Social Media',
            //         'Social Media');
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const AllStudents(),
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
      drawer: MyDrawer(data: controller.allStudents),
    );
  }
}
