import 'package:flutter/cupertino.dart';
import 'package:gsheets/gsheets.dart';
import 'package:gthqrscanner/controller/lecture_controller.dart';
import 'package:gthqrscanner/project/attendance_model/controller/my_controller.dart';
import 'package:gthqrscanner/project/google_sheets/student.dart';
import 'package:provider/provider.dart';

class AttendanceSheetApi {
//   static const credential = r'''
// {
//   "type": "service_account",
//   "project_id": "qrscan-341306",
//   "private_key_id": "93b7021499b9a1b7945e225d1b0c0ea16b184fec",
//   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCq64JgqEV4LpXP\nq8vKFXtEzgQGo+pyoj+kEmyFzZFvcfgwRf0fk6cqOQxXoccvD9WBUEWNRhgEAiE4\nQC3ZHcc89zzq4Jsd+R9lhCPLx558n95zSPA5wdFJccHfBdVAGS64fiPmxao8maQR\nIuTnZgrXXxYrxhqkP1ERamsQvz1uJsD3ca4uB1fv/pZjHAd158lxN7bDfq2pj/xI\njJeEj1YMTIlwFcEsxl8GvepB6PyffJr9jWUUTbYIZRqwSt651FnYRAf0kwOs+79d\nkLGWXm+LJIdeaN3FSosND+ZmKDpxFRlZnl7iC0qlucVsJ7md7GTdq1hdvczkgHcu\nk+uU6VZDAgMBAAECggEADofKBDSZ/08ajlahExODcMSA5B2gS1GOzoCAeFmTESHj\nwxrYG4yebAEAkxyeRdp3QLCV0R5R4VlbAKC4JRqaewzbwW4J0eEBccxrjKHyT875\nhtx/C7H1/GPu4upoiDP73FRg8fgA8njvUUOhqShsKIYdaOhFEIyPdEcTRg+0Bb6j\nENk8DhrLc1LARB3vlqvkXphXLIfrYJLyoAG80px4uhEl5hDWzGuB9U6gUGd50CYs\nhS0D2+q8p65Rw3xHCs4IOqkkfPQVvRuvC/EY/36JE3s5Kp7mg+5ZVYSJyftBplbH\nP4UixY11sNF2jWXdBbgnAvJ1ZaAC8ukQGt3RFxOLdQKBgQDcSw6QqGRyCUCQQLdL\n+WfWUB0TOCuhBePq4VGILZx9DzrIPRTEbMFFEZhKHcpnPVZzb7v3hhpCO6Kb2oCh\noVb1MZn02gQgRqmnYIg+0mB+CwacJ0axdakfW59hrnSBgQtVVN+MfyQitEH+dd2C\n5YUFs0ykhR8uv9YudBHn+pCFRwKBgQDGn7zVXix8uHx5j+bNVQ3hsU131Jt9pilQ\nPUlPyfF6AxJC/izxY5TJa0aWd7VxuM7MoSkeTE6U1x9KTWn/wEn5xE6KA1na9Zcr\nay/f41987eVrNgcUlirLHEw6cQgfgzC5yAfARiy7uP2Vhzy1ayJNFJGkqA5/f9lD\n7iJaIM7VJQKBgAI/reViIqxbVdJjJrvazumMJc/VafSZ18rFBA0M0iUgq6vxm62p\nootu84wGI9PL9370LAoJz2jPrQhEQb3kpLuaBwVN2G7v6blwrdNeWGfQ+v9LE1iq\nZ9CPIeBgZIYR6Ci11hZcEeVcy7OqRlmYuDPnsaeYSEo04R3WR3yDvUfvAoGAFTPw\nIIbREO9QullWNg0iUjlvH5+eiac3Oc2RCedw06mIRYaEnbAXrfi5rE5THDSyPr3l\necqDiPf96xygeCC6xOLjz2/UI7+bx5LFpYzMILX0i6FU2Cm/n7cBnCt8xoBmry5f\nRXM4S0HQMCojnOo22yua8IzQH2QyeUHugNiHu9ECgYATRoIUdlZd3pIyAoP1BtQ9\njai3AiAvlCjPRGUHKnXgEL0wYtBa0R+MQ79iyJAH1nUSF4Gqau0jaNNby+dsY0xE\nF6vYRIkn413uB7HAZtmN+CuHDEP4/H4nQo45qsBrdTlG5axyCe2zV+oJvPpRP1H4\n8ViITKXE5GFfIK5ck/lo9g==\n-----END PRIVATE KEY-----\n",
//   "client_email": "qr-scan@qrscan-341306.iam.gserviceaccount.com",
//   "client_id": "117064412806588845094",
//   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//   "token_uri": "https://oauth2.googleapis.com/token",
//   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//   "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/qr-scan%40qrscan-341306.iam.gserviceaccount.com"
// }
// ''';
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

  static const _spreadSheetId = '188e4oNSwBbbXYd_amyrnwnp4scU1eA711Pqx-dlTYFE';
  // static const spreadSheetId = '1XG-6nUqky4Mdt-zHXu0IDRif0v9aKPc8VmxOyiIIjcw';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? attendanceSheet;

  static Future init() async {
    try {
      final spresdsheet = await _gsheets.spreadsheet(_spreadSheetId);
      attendanceSheet = await _getWorkSheet(spresdsheet, title: LectureController.sheetName);

      final firstRow = Student.getFields();
      attendanceSheet!.values.insertRow(1, firstRow);
      // _tableHeader();
    } catch (error) {
      print('init Error: $error');
    }
  }

  // static _tableHeader() async {
  //   await _attendanceSheet!.values.insertValue('roll', column: 1, row: 1);
  //   await _attendanceSheet!.values.insertValue('name', column: 2, row: 1);
  //   await _attendanceSheet!.values.insertValue('email', column: 3, row: 1);
  // }

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
    // for(int i=1; i<5; i++){
    //   Provider.of<MyController>(context, listen: false)
    //     .updateTest(await _attendanceSheet!.values.map.row(i));
    // }
    // Provider.of<MyController>(context, listen: false)
    //     .updateTest(await _attendanceSheet!.values.map.row(1));
    
  }
  static Future insertDate(BuildContext context, String date, int r, int c) async {
    if (attendanceSheet == null) return;
    await attendanceSheet!.values.insertValue(date, column: c, row: r);
    // Provider.of<MyController>(context, listen: false)
    // //     // .updateTest(await _attendanceSheet!.values.row(1));
    //     .updateTest(await attendanceSheet!.values.map.allRows());
    
  }
  static Future getRows(BuildContext context) async {
    if (attendanceSheet == null) return;
    // _attendanceSheet!.values.map.appendRows(newRowList);
    Provider.of<MyController>(context, listen: false)
    //     // .updateTest(await _attendanceSheet!.values.row(1));
        .updateTest(await attendanceSheet!.values.map.allRows());
    // for(int i=1; i<5; i++){
    //   Provider.of<MyController>(context, listen: false)
    //     .updateTest(await _attendanceSheet!.values.map.row(i));
    // }
    // Provider.of<MyController>(context, listen: false)
    //     .updateTest(await _attendanceSheet!.values.map.row(1));
    
  }
  // static Future insertColumn(List<Map<String, dynamic>> today) async {
  //   // final secondColumn = ['a', 'b', 'c', 'd', 'e'];
  //   if (_attendanceSheet == null) return;
  // //   final firstRow = ['index', 'letter', 'number', 'label'];
  // // await _attendanceSheet!.values.insertRow(5, firstRow);

  // // insert list in column 'A', starting from row #2
  // final firstColumn = ['0', '1', '2', '3', '4'];
  // await _attendanceSheet!.values.insertColumn(5, firstColumn, fromRow: 4);

  //   // await _attendanceSheet!.values.map.insertColumnByKey('Today', secondColumn);
  // }
}
