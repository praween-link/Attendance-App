import 'package:flutter/material.dart';
import 'package:gthqrscanner/constants/colors/mycolor.dart';
import 'package:gthqrscanner/controller/branch_controller.dart';
import 'package:gthqrscanner/controller/student_controller.dart';
import 'package:gthqrscanner/views/branch_home_screen/drawer.dart';
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
    var branchController =
        Provider.of<BranchController>(context);
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.menu),
        // // leading: Builder(
        // //   builder: (BuildContext context) => GestureDetector(
        // //     child: Image.asset('assets/img/menu_icon.png'),
        // //     onTap: () => Scaffold.of(context).openDrawer(),
        // //   ),
        // // ),
        backgroundColor: MyColor.appBarColor,
        title: const Text('GTH Attendance App'),
      ),
      body: branchController.getAllBranchFromDB(),
      
      drawer: MyDrawer(data: controller.allStudents),
    );
  }
}
