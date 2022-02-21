import 'package:flutter/material.dart';
import 'package:gthqrscanner/project/connect_new_sheet.dart';
import 'colors/mycolor.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
    required this.data,
  }) : super(key: key);
  final dynamic data;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: MyColor.buttonSplaceColor2,
              image: DecorationImage(
                image: const AssetImage(
                  "assets/img/ghublogo.png",
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.1), BlendMode.dstATop),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  'Geeta Technical Hub',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: Colors.white),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.event_available_rounded),
            title: const Text('Connect New Sheet'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConnectNewSheet(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
