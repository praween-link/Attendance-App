import 'package:flutter/material.dart';
import 'package:gthqrscanner/constants/colors/mycolor.dart';
import 'package:gthqrscanner/controller/branch_controller.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ConnectNewSheet extends StatefulWidget {
  static const routeName = '/connectNewSheet';
  const ConnectNewSheet({Key? key}) : super(key: key);

  @override
  _ConnectNewSheetState createState() => _ConnectNewSheetState();
}

class _ConnectNewSheetState extends State<ConnectNewSheet> {
  final _formKey = GlobalKey<FormState>();

  String key = '';
  String spreadSheetId = '';
  String spreadSheetTitle = '';
  @override
  Widget build(BuildContext context) {
    var branchController =
        Provider.of<BranchController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) => GestureDetector(
            child: const Icon(
              Icons.chevron_left_sharp,
              size: 32,
            ),
            onTap: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: MyColor.appBarColor,
        title: const Text('Add New Sheet'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
          const ListTile(title: Text('Email: attendance@custom-resource-341212.iam.gserviceaccount.com'),),
          const SizedBox(height: 20.0),
                TextFormField(
                  onChanged: (value) => setState(() => key = value),
                  decoration: const InputDecoration(
                    hintText: 'Without any space and special chractors*',
                    label: Text('Spread Sheet Key*'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Key cannot be empty!';
                    }
                  },
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  onChanged: (value) => setState(() => spreadSheetId = value),
                  decoration: const InputDecoration(
                    hintText: 'Enter spread sheet id*',
                    label: Text('Spread Sheet Id*'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Id cannot be empty!';
                    }
                  },
                ),
                const SizedBox(height: 5.0),
                TextFormField(
                  onChanged: (value) =>
                      setState(() => spreadSheetTitle = value),
                  decoration: const InputDecoration(
                    hintText: 'Enter spread sheet title*',
                    label: Text('Spread Sheet Title*'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Title cannot be empty!';
                    }
                  },
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.SCALE,
                        dialogType: DialogType.WARNING,
                        body: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Add $spreadSheetTitle sheet!',
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Are you sure to new sheet!',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        btnCancelOnPress: () {},
                        btnCancelText: 'NO',
                        btnOkOnPress: () {
                          //validate
                          branchController.addNewSheet(
                            key: key,
                              spreadSheetId: spreadSheetId,
                              spreadSheetTitle: spreadSheetTitle);
                          Navigator.pop(context);
                        },
                        btnOkText: 'YES',
                      ).show();
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Add New Lecture',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(MyColor.buttonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
