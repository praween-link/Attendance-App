import 'package:flutter/material.dart';
import 'package:gthqrscanner/constants/colors/mycolor.dart';

class BranchHeader extends StatelessWidget {
  const BranchHeader({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 35),
        Container(
          margin: const EdgeInsets.only(left: 50, right: 50),
          child: ClipRRect(
            child: Image.asset('assets/img/ghublogo.png'),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Geeta Technical Hub', //Attendance App
          style: TextStyle(
            color: MyColor.textcolor5,
            fontSize: 20.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        Text(
          'ATTENDANCE',
          style: TextStyle(
            color: MyColor.textcolor5,
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
