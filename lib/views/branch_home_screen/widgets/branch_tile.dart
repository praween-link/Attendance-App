import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gthqrscanner/constants/colors/mycolor.dart';
import 'package:gthqrscanner/controller/branch_controller.dart';
import 'package:gthqrscanner/views/lecture_screen/lectures.dart';
import 'package:provider/provider.dart';

class BranchTile extends StatelessWidget {
  const BranchTile({Key? key, required this.data, required this.index})
      : super(key: key);
  final List<QueryDocumentSnapshot<Object?>> data;
  final int index;

  @override
  Widget build(BuildContext context) {
    var branchController = Provider.of<BranchController>(context);
    return Padding(
      padding:
          const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 8.0, top: 8.0),
      child: GestureDetector(
        onTap: () {
          branchController.myBranchId(data[index - 1].id);
          branchController.mySpreadSheetId(data[index - 1]['spreadSheetId']);
          branchController.mySpreadSheetTitle(data[index - 1]['title']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Lectures(),
            ),
          );
        },
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              data[index - 1]['title'],
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          decoration: BoxDecoration(
              color: MyColor.buttonColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(50.0),
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(4, 8),
                  color: MyColor.buttonSplaceColor5,
                  blurRadius: 8.0,
                  spreadRadius: 2,
                ),
              ]),
        ),
      ),
    );
  }
}