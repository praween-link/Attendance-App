import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gthqrscanner/constants/colors/mycolor.dart';
import 'package:gthqrscanner/controller/student_controller.dart';
import 'package:provider/provider.dart';

class ScanQRCode extends StatefulWidget {
  const ScanQRCode({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  _ScanQRCodeState createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  String scanningError = '';
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: MyColor.buttonColor,
      splashColor: MyColor.buttonSplaceColor5,
      onPressed: () {
        qrscan(context);
      },
      label: const Text(
        'Scan QR Code',
        style: TextStyle(
          fontSize: 22.0,
        ),
      ),
      icon: const Icon(
        Icons.camera,
        size: 40,
      ),
    );
  }

  Future qrscan(BuildContext constext) async {
    var controller = Provider.of<MyController>(context, listen: false);
    try {
      await BarcodeScanner.scan().then(
        (value) async {
          controller.changeQRResult(result: value.rawContent.toString());
        },
      );
    } on PlatformException catch (error) {
      if (error.code == BarcodeScanner.cameraAccessDenied) {
        setState(() =>
            scanningError = 'The user did not grant the camera permission!');
      } else {
        setState(() => scanningError = 'Unknown error: $error');
      }
    } on FormatException {
      setState(() => scanningError =
          'null (User returned using the "back"-button before scan');
    } catch (error) {
      setState(() => scanningError = 'Unknown error: $error');
    }
  }
}
