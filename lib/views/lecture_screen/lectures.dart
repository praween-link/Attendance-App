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
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 500,
                    color: Colors.amber,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                itemCount: BranchController.allLecutres.length,
                                itemBuilder: ((context, index) {
                                  return GestureDetector(
                                    onLongPress: () {
                                      List ll = BranchController.allLecutres;
                                      ll.remove(
                                          BranchController.allLecutres[index]);
                                      branchController.deleteLecture(
                                          BranchController.branchId, ll);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      color: Colors.white.withOpacity(0.5),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          BranchController.allLecutres[index],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            TextField(
                              controller: lectureInputController,
                              decoration: const InputDecoration(
                                  label: Text('Lecture'),
                                  hintText: 'Enter new lecture'),
                            ),
                            ElevatedButton(
                              child: const Text('Add Lecture'),
                              onPressed: () {
                                branchController.addLecture(
                                    BranchController.branchId,
                                    lectureInputController.text);
                                branchController.getAllBranchFromDB();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
