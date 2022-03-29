import 'package:flutter/cupertino.dart';
import 'package:gsheets/gsheets.dart';
import 'package:gthqrscanner/controller/branch_controller.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:gthqrscanner/controller/student_controller.dart';
import 'package:gthqrscanner/model/student.dart';
import 'package:provider/provider.dart';

class AttendanceSheetApi {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "attendance-342507",
  "private_key_id": "5fb3f1d634a5f03e278cfe5ba2e7acb1dd1c492a",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDONzk6QR9olg/F\nyXHLS7R0Q+FJAx7Sh36m8Yvz4cbWQ2pc2R20DGGO70EQ3DuqRj7bqbBR4ErMKvGw\n36GQ7YPrP1Bp2wVtNsxJ8LSGiZ6AR1l/pi4Ibe2Jz+6EHrszCaWX96GSaYM61Hcd\n/OqeNMyfA73DpLfifG6VKH9fWnyNnOxxzLqHNnnNK20kmMhfrubUed/DOw72ko1g\ndSz8HLErYPzaDJejjFum2zetA67PxP+96s1Mh4g+8JVRSalWiDXMZbNfBQYk0Slr\nZc3UyuBR7Cd1HZMdVOrhoieEl8+56XoszqFM8IYNybFjdze7FJK6R1y8Nw49S2Tu\nXQJxIdP9AgMBAAECggEAHyKZYmFIw7q8gOlsY/x3L4K8NhDhi3nntn8L2XPCWMFv\nArvJT1D7PeCD227VF11pyjKxq3sI8BCf00vAkig6Xb9+fa0TAa1fZN6R8yo+IzIi\nojJOCvnF/qPFaG9XZlpThUFfRMLnjG9d2MpCBkcEihG/ihWJqgmNjLnDmXsJCTxd\nvYR36eSKc/2XxkVv0NyXncYt6oxWjRBOuO6Xs6nTc2I6vw6nk2ahc3+Pukf7LjAW\nlOKWMTNTRPzTwEv+1L286Cc8GDhcRz+wU0ePGYzEypDFVHIOFRTPkedW5rB/2sI7\nYZO+RsnFezOEBDCzkW1xYx1ySKN93yRyB72N2Q7YxQKBgQDy5oxi5oWkYXsAWmhh\ni8Fz1ndEduBvC1H0v6e/t6UOcibKdW8pjPR4l8GcIFKboObbrN3CjSvABegTkFpq\nb2qg4aIPuQHwn5NX1A4BtRopyItjdcroeekpD+HeZ6TgS600MRQLFnSnws5M2/BB\nE0pf3zvrmHSHel5I0jaHMssC+wKBgQDZVjWETHd+Psz3rB7pAZs3elrJBUCLIjUW\nvwnLfEJCbIASpB6XP6VykNH2kfOAW2lp+PXIB66pqQdz71rXtSSGQCmyTlI9CV5t\nkntprekAPH+vWJ81BbXI8QGkdxNQALfvrjAz/YNj19PNre2TpCrixLjFjoMaDucu\nRF2ZQ8ETZwKBgHac9KL7FPm/jHQQsfYoa/BoI1ewgUpYic3tpTnusNBMF/s3u2/b\n4CnfWXEnK4/J09IkKSpvC5U6jSi4jh55h+VGKYBqBLN/CVGTQL++sycCQmbwR4Sc\nu6oMkmyrygyph8v7x2Det1qQu3M216y/gcstVLJogUcDD3WaCXyd5hrvAoGBAMno\nAQfLUieCiEB/MqgcyeocTUL7Eh8vxEpBaAQWiCfVTJYEyjaQ9k8cozKCHMleIuxE\nUXFnUahkU3wtHSPQMQJXkWUIxfXWQldhAi4HVrLVgXmQxzcm+t6Wp4P264YjZL3S\nAQ4LsoiK9UXbEx9aIE1TnKRL5RfMSJD/CkVcYH55AoGBAJjrNHtxg7z9zIQGok4J\nKtXZY1FyePlCktfjfYddWzTgG663wexHQdcuX4WtyEpjlz9/JGq7Skm8JigdjTIk\nJeG+lhMO55k42eV83zn9R9dS41dSSy/TQ0qrUA2jK7cduQ6WwPe2dBL8KzVNrZFM\n680t6fhjoDbQhqWhq+xBUZdV\n-----END PRIVATE KEY-----\n",
  "client_email": "gth-attendance@attendance-342507.iam.gserviceaccount.com",
  "client_id": "111675130649885899781",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gth-attendance%40attendance-342507.iam.gserviceaccount.com"
}

''';

  static final _gsheets = GSheets(_credentials);
  static Worksheet? attendanceSheet;
  static Worksheet? studentSheet;

  static Future init() async {
    try {
      final spresdsheet =
          await _gsheets.spreadsheet(BranchController.spreadSheetId);
      attendanceSheet =
          await _getWorkSheet(spresdsheet, title: LectureController.sheetName);

      final firstRow = Student.getFields();
      attendanceSheet!.values.insertRow(1, firstRow);
      // _tableHeader();
    } catch (error) {
      print('init Error: $error');
    }
  }

  static Future<Worksheet> _getWorkSheet(Spreadsheet spreadsheet,
      {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (error) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insertRow(
      List<Map<String, dynamic>> newRowList, BuildContext context) async {
    if (attendanceSheet == null) return;
    await attendanceSheet!.values.map.appendRows(newRowList);
    // await Provider.of<MyController>(context, listen: false)
    //         .updateTest(await attendanceSheet!.values.row(3));////////////////////////////////////////////////////////////////////////////////////
    // .updateTest(await attendanceSheet!.values.map.allRows());
    return true;
  }

  static Future insertDate(
      BuildContext context, String date, int r, int c) async {
    if (attendanceSheet == null) return;
    await attendanceSheet!.values.insertValue(date, column: c, row: r);
  }

  // static Future getRows(BuildContext context) async {
  //   if (attendanceSheet == null) return;
  //   // _attendanceSheet!.values.map.appendRows(newRowList);
  //   Provider.of<MyController>(context, listen: false)
  //       .updateTest(await attendanceSheet!.values.map.allRows());
  // }

  ///---------------------- GET STUDENT DATA FROM GOOGLE SHEET -----------------------///
  static Future getStudentData(
      {required BuildContext context,
      required String ssid,
      required String sheetname}) async {
    try {
      final spresdsheet = await _gsheets.spreadsheet(ssid);
      studentSheet = await _getWorkSheet(spresdsheet, title: sheetname);
    } catch (error) {
      print('Error: $error');
    }
    if (studentSheet == null) return;
    Provider.of<MyController>(context, listen: false)
        .updateTest(await studentSheet!.values.map.allRows());
  }

  // Fetch all roll numbers
  static Future getRows(BuildContext context) async {
    // final spresdsheet =
    //       await _gsheets.spreadsheet('199Oh8_o0xCSwfrTSy_1yHpQTloAfpBS9_PhD304gJa8');
    // attendanceSheet =
    //       await _getWorkSheet(spresdsheet, title: 'APTITUDE');

    if (attendanceSheet == null) return;
    // _attendanceSheet!.values.map.appendRows(newRowList);
    Provider.of<MyController>(context, listen: false)
        .gettestAllData(await attendanceSheet!.values.map.allRows());
  }
}
