import 'package:flutter/cupertino.dart';
import 'package:gsheets/gsheets.dart';
import 'package:gthqrscanner/controller/branch_controller.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:gthqrscanner/project/attendance_model/controller/my_controller.dart';
import 'package:gthqrscanner/project/google_sheets/student.dart';
import 'package:provider/provider.dart';

class AttendanceSheetApi {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "custom-resource-341212",
  "private_key_id": "ce20a04d314d8a0ebd052d53402d00475f99d913",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDnso3E5eBgJ4QK\nbE9jFthxE0dI9jxrBAub1bb3iS6zuwBWaqY8Gu/tdOiHO1UL2ahTszHSkWI6P6V1\nkUYQ5x7dNi6xvhlMBzXfODQdD1s3fky46xuJBJIzMzYxbMXqaI/IkHKaxDS35vTp\nXUSzvmtmBk/KVYzGirte+VmPxIl9Jyh9fOgRNh2djzAO5EyGeBCV7zHp4flWyodV\npuCpFR+gdy6GUikH7eknJdMgU+yZ7x3IXdP/1eAqC6EB22iU9pEOOX5SC/cgkfPO\nSLUY3nrHWOtwctSP9Ylz1LxmbHa3D3hcp7ghAbqR/tAKSH/UHulrvHOgnzEcer5H\ngsgKVkkRAgMBAAECggEAEoc9U2RnToPVHnjt2kiJPiBNYDYiERQYPOSDcVpyNnjl\npy4ierD+xHhHtgoWcXr859XvIzMcGKNeqb8DIYvnScew8TwjTWiliWMMYSc0DgUs\nFnzlTU46cMdkyzazFwfjOPs60Z86G1tn9MIldyhAR2mJd5k4HOfFjGvtRRQcQzqM\n7AJacvt5mcEtplkEipjfqR7tSPTaVAy+NqPm+X7f9ofMFX9za9FbH69C8XcFN5kC\nGQ1j4JsXGLK5bz1fTAj1X2JjEGvGkqX+Sz/enQZHD6MFs3UCUMo9yEQMX7+Y1Z4T\nvvYCOaSgBLWvDqJ8SOSm1rIgJ7CvimvN7wUZwAT0twKBgQD/UbHN5WHKKAGW2wmp\nRKbV++wcgVgc4Cpd6p2gcNVsl3OgQxpEcX0e8P/DlKyNWAgZb2and/7gpO2DdTN6\nZr5DXMYAa0E+SSkHOCLDwvf7xleI5kagY0mwhMVcVX+KfhUEW+KiYUPp1qc5CCNO\nec8hK+EKy97JRAu2MrF/QmdvawKBgQDoULuaefS/lFJFIqCSbHLiXhjAgFhEcpFd\nUNkwEH6bwYmo+93+XaiRbsz9YSy/pLm+C5ms+493wnImigDUmv16zZc53eSrGDwo\nlVvR2b6I8Lw3kk25Xb5fjFcLJaVwYFZTOYSSuarUkPUTk9zOICmD8a/grbKpAJwm\nJ8S//Ji0cwKBgQC7P27nUhMl77E6semj+nVg+iFvxmyYwM5Rkn+H6zibK3fhUVUy\nXQkmaBkrlx31i1plTQ48RATpPAv1HT9jxXZEcQXFyONQitdMNB9K8vJr9Eq+XCPv\n/OFOVBFqZknjiBRh3gGYlTz5gjOh4BYEt9Dwwv2IrXv2n7D3LrZ+XnT9gQKBgQC1\nCGSJBkxBFlXd5hP2xmfoGqdzKxCdliHM8/mrSM9AlNqvQkZFt7pqSkuXj6gNV1Ie\n1G9Wq1mrW20Utynag0TP83HK+Cz/Xw1SGsHIj8O4dtBVBb9nmbOGRZh26Uk4fvoG\nNKYoqGKE7sjsDqdcQRfY5/fEP9cfd4g2+3qImVBuHQKBgB8q14Luo5fASF5mleig\n3FBmaT6qtWq0IjJlmh8brHV7mFuLxeR3J6PeeG8HBPDdkRmgZAZ8azeCWnZLluU7\ngPJTO24nk8iKMMcoBDByN1/4/GVi9h0k+h46Wq4pGoauXzKAhO8NkUip58ROUp+s\ndpQ7PiLxa3eSxMJeGiF4W98u\n-----END PRIVATE KEY-----\n",
  "client_email": "attendance@custom-resource-341212.iam.gserviceaccount.com",
  "client_id": "101769328706120077217",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/attendance%40custom-resource-341212.iam.gserviceaccount.com"
}

''';
  //Email: attendance@custom-resource-341212.iam.gserviceaccount.com
  // static const _spreadSheetId = '188e4oNSwBbbXYd_amyrnwnp4scU1eA711Pqx-dlTYFE';
  // static const _spreadSheetId = '16DGaFt2bQRdXhfGDZQulYcGlYdTv6RnvjvJwhNF1FMc';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? attendanceSheet;

  static Future init() async {
    try {
      final spresdsheet = await _gsheets.spreadsheet(BranchController.spreadSheetId);
      attendanceSheet = await _getWorkSheet(spresdsheet, title: LectureController.sheetName);

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
    attendanceSheet!.values.map.appendRows(newRowList);
    Provider.of<MyController>(context, listen: false)
    //     // .updateTest(await _attendanceSheet!.values.row(1));
        .updateTest(await attendanceSheet!.values.map.allRows());
    
  }
  static Future insertDate(BuildContext context, String date, int r, int c) async {
    if (attendanceSheet == null) return;
    await attendanceSheet!.values.insertValue(date, column: c, row: r);
    
  }
  static Future getRows(BuildContext context) async {
    if (attendanceSheet == null) return;
    // _attendanceSheet!.values.map.appendRows(newRowList);
    Provider.of<MyController>(context, listen: false)
        .updateTest(await attendanceSheet!.values.map.allRows());
    
  }
}
