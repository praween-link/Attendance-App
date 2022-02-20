import 'package:flutter/material.dart';
import 'package:gthqrscanner/project/add_lecture.dart';
import 'package:gthqrscanner/project/attendance_model/add/add_student.dart';
import 'package:gthqrscanner/project/attendance_model/students/view_all_students.dart';
import 'package:gthqrscanner/project/home/home_screen.dart';
import 'package:gthqrscanner/project/splash_screen.dart';
import 'package:gthqrscanner/src/sample_feature/sample_item_details_view.dart';
import 'package:gthqrscanner/src/sample_feature/sample_item_list_view.dart';
import 'package:gthqrscanner/src/settings/settings_controller.dart';
import 'package:gthqrscanner/src/settings/settings_view.dart';

class Routes {
  MaterialPageRoute<void> myMaterialPageRoute(
      RouteSettings routeSettings, SettingsController settingsController) {
    return MaterialPageRoute<void>(
      settings: routeSettings,
      builder: (BuildContext context) {
        switch (routeSettings.name) {
          case SettingsView.myroute:
            return SettingsView(controller: settingsController);
          case SampleItemDetailsView.myroute:
            return const SampleItemDetailsView();
          case SampleItemListView.myroute:
            return const SampleItemListView();
          case HomeScreen.myroute:
            return const HomeScreen();
          case AddNewStudent.myroute:
            return const AddNewStudent();
          case AllStudents.routeName:
            return const AllStudents();
          case AddNewLecture.routeName:
            return const AddNewLecture();
          case SplashScreen.routeName:
            return const SplashScreen();
          default:
            return const HomeScreen();
        }
      },
    );
  }
}
