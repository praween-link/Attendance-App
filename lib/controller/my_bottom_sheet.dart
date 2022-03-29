import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'branch_controller.dart';
import 'student_controller.dart';

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({Key? key}) : super(key: key);

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var myController = Provider.of<MyController>(context);
    return Container(
      height: 400,
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
                      onTap: () {
                        // var branchController = Provider.of<BranchController>(
                        //     context,
                        //     listen: false);
                        myController.seletedLectureUpdate(
                            BranchController.allLecutres[index]);

                        Navigator.pop(context);
                      },
                      child: Container(
                          color: Colors.white.withOpacity(0.5),
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child:
                                  Text(BranchController.allLecutres[index]))),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
