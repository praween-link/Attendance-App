import 'package:flutter/material.dart';
import 'package:gthqrscanner/src/sample_feature/sample_item_details_view.dart';
import 'package:gthqrscanner/src/sample_feature/sample_item_list_view.dart';
import 'package:gthqrscanner/src/settings/settings_controller.dart';
import 'package:gthqrscanner/src/settings/settings_view.dart';
import 'package:gthqrscanner/test.dart';
import 'package:gthqrscanner/views/add/student/add_student.dart';
import 'package:gthqrscanner/views/add/lecture/add_lecture.dart';
import 'package:gthqrscanner/views/add/branch/connect_new_sheet.dart';
import 'package:gthqrscanner/views/branch_home_screen/home_screen.dart';
import 'package:gthqrscanner/views/splash_screen.dart';
import 'package:gthqrscanner/views/students/view_all_students.dart';

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
          case ConnectNewSheet.routeName:
            return const ConnectNewSheet();
          case TestScreen.routeName:
            return const TestScreen();
          default:
            return const HomeScreen();
        }
      },
    );
  }
}
