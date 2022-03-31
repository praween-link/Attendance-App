import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gthqrscanner/constants/colors/mycolor.dart';
import 'package:gthqrscanner/controller/branch_controller.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:provider/provider.dart';

import '../add/lecture/add_lecture.dart';

class Lectures extends StatefulWidget {
  const Lectures({Key? key}) : super(key: key);

  @override
  State<Lectures> createState() => _LecturesState();
}

class _LecturesState extends State<Lectures> {
  final TextEditingController lectureInputController = TextEditingController();
  // bool searching = false;
  @override
  Widget build(BuildContext context) {
    var lectureController =
        Provider.of<LectureController>(context, listen: false);
    var branchController = Provider.of<BranchController>(context);
    // var lectureC = Provider.of<LectureController>(context);

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
        title: const Text('GTH Attendance App'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddNewLecture(),
                ),
              );
            },
            icon: const Icon(Icons.add_to_photos_rounded),
          ),
          //
          IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
                isScrollControlled: true,
                // backgroundColor: Colors.grey.withOpacity(0.9),
                context: context,
                builder: (context) => SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.8,
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Text(
                                'All lectures_',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                          const Divider(),
                          Expanded(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: BranchController.allLecutres.length,
                              itemBuilder: ((context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 15.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              BranchController
                                                  .allLecutres[index],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              AwesomeDialog(
                                                context: context,
                                                animType: AnimType.SCALE,
                                                dialogType: DialogType.WARNING,
                                                body: Center(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Text(
                                                        'Delete Lecture!',
                                                        style: TextStyle(
                                                          color: Colors.orange,
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(height: 8),
                                                      Text(
                                                        'Are you sure to delete this lecture!',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                btnCancelOnPress: () {},
                                                btnCancelText: 'NO',
                                                btnOkOnPress: () {
                                                  List ll = BranchController
                                                      .allLecutres;
                                                  ll.remove(BranchController
                                                      .allLecutres[index]);
                                                  branchController
                                                      .deleteLecture(
                                                          BranchController
                                                              .branchId,
                                                          ll);
                                                  Navigator.pop(context);
                                                },
                                                btnOkText: 'YES',
                                              ).show();
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: const [
                              Text(
                                'Add new lecture_',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 5.0),
                          TextField(
                            controller: lectureInputController,
                            decoration: InputDecoration(
                              label: const Text('Lecture'),
                              hintText: 'Enter new lecture',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                'Add Lecture',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              branchController.addLecture(
                                  BranchController.branchId,
                                  lectureInputController.text);
                              branchController.getAllBranchFromDB();
                              lectureInputController.clear();
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  MyColor.appBarColor),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      // borderRadius: const BorderRadius.only(
                      //   topRight: Radius.circular(20.0),
                      //   topLeft: Radius.circular(20.0),
                      // ),
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add_circle_outline_outlined),
          ),
        ],
      ),
      body: lectureController.getAllLecutresFromDB(),
    );
  }
}
