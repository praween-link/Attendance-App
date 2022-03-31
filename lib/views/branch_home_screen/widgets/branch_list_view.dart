
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gthqrscanner/controller/branch_controller.dart';
import 'package:provider/provider.dart';

import 'branch_header.dart';
import 'branch_tile.dart';

class BranchListViewBuilder extends StatelessWidget {
  const BranchListViewBuilder({Key? key, required this.data}) : super(key: key);
  final List<QueryDocumentSnapshot<Object?>> data;

  @override
  Widget build(BuildContext context) {
    var branchController = Provider.of<BranchController>(context);
    return ListView.builder(
        itemCount: data.length + 1,
        itemBuilder: (context, int index) {
          if (index != 0) {
            branchController
                .myAllLecutres(data[index - 1]['lectures'].cast<String>());
          }
          return index == 0
              ? const BranchHeader()
              : BranchTile(data: data, index: index);
        });
  }
}
