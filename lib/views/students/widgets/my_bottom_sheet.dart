import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/branch_controller.dart';
import '../../../controller/student_controller.dart';

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({Key? key}) : super(key: key);

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var myController = Provider.of<MyController>(context);
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height / 2.5,
          padding: const EdgeInsets.all(30.0),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: BranchController.allLecutres.length,
            itemBuilder: ((context, index) {
              return GestureDetector(
                onTap: () {
                  // var branchController = Provider.of<BranchController>(
                  //     context,
                  //     listen: false);
                  myController.seletedLectureUpdate(
                      BranchController.allLecutres[index], index);

                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                      child: Text(
                        BranchController.allLecutres[index],
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                  ),
                ),
              );
            }),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }
}
